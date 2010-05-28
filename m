Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838Ab0E1Qmz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 12:42:55 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54065 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304Ab0E1Qmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 12:42:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ImxqsBbnLLYwEMyKJ9JxpdyJAG1TTfmoZMXck85U532W06JQ6iDJeYngD5mLeTf5Rm
         o1bHChT9M1ZwqBNVRdqYYB+VsRTlo3RFUNrO3c+YhdNEtb7EYmSuJoCBEvohfmtzgLoR
         Z1HN78YKcoN7454PrxYEWr6A6SoobcI5yxBMQ=
MIME-Version: 1.0
In-Reply-To: <20100526123443.GB8905@stefan-thinkpad.transitives.com>
References: <20100526123443.GB8905@stefan-thinkpad.transitives.com>
Date: Fri, 28 May 2010 17:42:51 +0100
Message-ID: <AANLkTil8BiuzrmacV7Lpx1wES0EvLSiVmcfwtSY6Zis2@mail.gmail.com>
Subject: Re: Perf trace event parse errors for KVM events
From: Stefan Hajnoczi <stefanha@gmail.com>
To: linux-perf-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get parse errors when using Steven Rostedt's trace-cmd tool, too.

Any ideas what is going on here?  I can provide more info (e.g. trace
files) if necessary.

Stefan
