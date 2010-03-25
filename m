Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab0CYAlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 20:41:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43397 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819Ab0CYAlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 20:41:17 -0400
X-Authority-Analysis: v=1.0 c=1 a=1jx-JgeO208A:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=MdFZble76LHdbGEffRcA:9 a=4XXGhTXZbKI54sh2OefPshBcbuYA:4 a=PUjeQqilurYA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 5/5] trace-cmd: Simplify Makefile, and remove confusing
  messages.
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: John Kacur <jkacur@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Darren Hart <dvhltc@us.ibm.com>
In-Reply-To: <520f0cf11003241731r129590a1ha0bf28312659e87f@mail.gmail.com>
References: <1269473050-11413-1-git-send-email-jkacur@redhat.com>
	 <1269473050-11413-6-git-send-email-jkacur@redhat.com>
	 <1269476692.2957.3267.camel@gandalf.stny.rr.com>
	 <520f0cf11003241731r129590a1ha0bf28312659e87f@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 24 Mar 2010 20:41:15 -0400
Message-ID: <1269477675.2957.3285.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-25 at 01:31 +0100, John Kacur wrote:

> If you don't like this, I could just submit the README changes
> but I would at least recommend that we change the messages
> so they don't like like Makefile errors.
> 
> For example: REMINDER: You can make the gui by typing make gui
> instead of the *** that match make file errors.

How about:

NOTE: to build the gui, type make gui

-- Steve


