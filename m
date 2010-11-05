Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab0KENNJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 09:13:09 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:36716 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab0KENNI convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Fri, 5 Nov 2010 09:13:08 -0400
Message-Id: <4CD410EE0200007800020BBF@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 05 Nov 2010 13:13:02 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Andreas Herrmann" <herrmann.der.user@googlemail.com>
Cc: <mingo@elte.hu>, "Yinghai Lu" <yinghai@kernel.org>, <tglx@linutronix.de>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86-64: more fixes and cleanup to AMD Fam10 MMCONF
	 enabling
References: <4CD3F18E0200007800020B6D@vpn.id2.novell.com>
 <20101105130710.GA32266@alberich.amd.com>
In-Reply-To: <20101105130710.GA32266@alberich.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 05.11.10 at 14:07, Andreas Herrmann <herrmann.der.user@googlemail.com>
wrote:
> On Fri, Nov 05, 2010 at 10:59:10AM +0000, Jan Beulich wrote:
>> Unfortunately it turned out the original code had more issues: We want
>> to place the region above 4G in any case (even if TOM2 isn't enabled
>> or invalid), and the base mask definition was improperly typed (thus
> 
> I am just curios. Do you actually have access to a system where TOM2
> isn't properly configured?

No - but since it was relatively obvious that the TOM2-not-set case
needed correction, it seemed simple and reasonable to also adjust
the TOM2-set-to-below-4G case.

Jan

