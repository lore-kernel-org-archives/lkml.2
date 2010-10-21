Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab0JUJWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 05:22:16 -0400
Received: from canuck.infradead.org ([134.117.69.58]:46866 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab0JUJWP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 05:22:15 -0400
Subject: Re: Finishing off cpumask...
From: Peter Zijlstra <peterz@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>, anton@samba.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
In-Reply-To: <201010211735.23918.rusty@rustcorp.com.au>
References: <201010211735.23918.rusty@rustcorp.com.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 21 Oct 2010 11:21:47 +0200
Message-ID: <1287652907.3488.64.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-21 at 17:35 +1030, Rusty Russell wrote:
> The next two turn off and break
> old-style cpumask uses when CONFIG_CPUMASK_OFFSTACK is set, 

Breaking old style for !CONFIG_CPUMASK_OFFSTAK too would be awesome, but
I guess that's hard to do?
