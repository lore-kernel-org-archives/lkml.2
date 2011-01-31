Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab1AaH7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 02:59:32 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:35486 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075Ab1AaH7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 02:59:31 -0500
Date: Sun, 30 Jan 2011 23:59:28 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [Patch] rcupdate: remove dead code
Message-ID: <20110131075928.GD2145@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1296382988-16564-1-git-send-email-amwang@redhat.com>
 <4D453CAC.4010305@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D453CAC.4010305@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 30, 2011 at 06:25:48PM +0800, Cong Wang wrote:
> 于 2011年01月30日 18:23, Amerigo Wang 写道:
> >DEBUG_OBJECTS_RCU_HEAD depends on PREEMPT, so #ifndef CONFIG_PREEMPT
> >is totally useless in kernel/rcupdate.c.
> 
> By "useless" I meant the code under #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD,
> of course. :)

Yep, I did interpret it that way.  ;-)

							Thanx, Paul
