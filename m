Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab0GJDci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 23:32:38 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:47997 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab0GJDch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 23:32:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=WFAAVmMVr88wopmvT29kJUCIUqb0GT/qNIudE6EL/NSUOPolHrsUJ+n35PKzjMKseN
         WqD8C4P46ZQHjbfPokpEa6uiaao6ARBj0MyLWSPma5LWeZ32/wZOwc84eE9eD2UDS+zz
         n/N4eHMuPfeCxISPVx3X8dBhJ8IRbto9uPUHs=
Subject: Re: [PATCH] tracing: recordmcount.pl: Fix $mcount_regex for MIPS.
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: rostedt@goodmis.org
Cc: David Daney <ddaney@caviumnetworks.com>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org, Li Hong <lihong.hi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Matt Fleming <matt@console-pimps.org>,
       Ralf Baechle <ralf@linux-mips.org>
In-Reply-To: <1278721562.1537.169.camel@gandalf.stny.rr.com>
References: <1278712325-12050-1-git-send-email-ddaney@caviumnetworks.com>
	 <1278721562.1537.169.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Sat, 10 Jul 2010 11:32:30 +0800
Message-ID: <1278732750.4750.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-09 at 20:26 -0400, Steven Rostedt wrote:
> 
> I'd like to get an Acked-by from Ralf and Wu before pulling this.
> 

It is ok for me ;)

Acked-by: Wu Zhangjin <wuzhangjin@gmail.com>

Regards,
	Wu Zhangjin

