Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab1EDV0n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 17:26:43 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64120 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166Ab1EDV0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 17:26:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=S54ApmNU23fFWXf9M9AeB6+HeHHrS7VtiqOBU7nRqhrHAiA5yTP2sBYCHdoomwxh15
         FctBM0edjD29gdIhxqWvxJgYy+dPS8vd5ILjEecKhDhTNeCuJatYjjxu9JKJgw62MN5R
         w5e+V5hsQiD7f81JGy6U0IftJComBxMEb1m/k=
Date: Wed, 4 May 2011 23:26:38 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trace: Check for waiting readers before calling
 wakeup()
Message-ID: <20110504212635.GE1804@nowhere>
References: <1304467520-31530-1-git-send-email-vnagarnaik@google.com>
 <BANLkTimorXOLcvB2dwXMAH8n2UU-C2ntcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimorXOLcvB2dwXMAH8n2UU-C2ntcA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 02:21:28PM -0700, Vaibhav Nagarnaik wrote:
> Steven, Frederic
> 
> Does this patch look ok?
> 
> 
> 
> Vaibhav Nagarnaik
> 

No problem for me. I'll let Steve give the last word.
