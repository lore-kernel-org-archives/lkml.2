Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab0KMQS0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 11:18:26 -0500
Received: from canuck.infradead.org ([134.117.69.58]:53007 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482Ab0KMQSZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 11:18:25 -0500
Subject: Re: Oprofile bug ?
From: Peter Zijlstra <peterz@infradead.org>
To: Sylvain GENEVES <Sylvain.Geneves@inrialpes.fr>
Cc: "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robert.richter" <robert.richter@amd.com>
In-Reply-To: <c69374315a434a8bab96c55e4542bc81.squirrel@webmail.inrialpes.fr>
References: <c69374315a434a8bab96c55e4542bc81.squirrel@webmail.inrialpes.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 13 Nov 2010 17:18:36 +0100
Message-ID: <1289665116.2084.887.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-12 at 22:11 +0100, Sylvain GENEVES wrote:
> Anyone has any idea on what is happening ?

Yeah, the oprofile code is terminally broken, it uses
__copy_from_user_inatomic() from NMI context.


