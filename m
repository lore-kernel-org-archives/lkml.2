Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab2A1AjX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 19:39:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54495 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab2A1Ail (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 19:38:41 -0500
X-Authority-Analysis: v=2.0 cv=HeuWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=oR1afkCu1uAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=Z4svKac-VC-yKWHlqOUA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1327711116.22710.147.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH v5 1/3] seccomp: kill the seccomp_t typedef
From: Steven Rostedt <rostedt@goodmis.org>
To: Will Drewry <wad@chromium.org>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        torvalds@linux-foundation.org, segoon@openwall.com, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, luto@mit.edu, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, oleg@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        corbet@lwn.net, alan@lxorguk.ukuu.org.uk, indan@nul.nu,
        mcgrathr@chromium.org
Date: Fri, 27 Jan 2012 19:38:36 -0500
In-Reply-To: <CABqD9hZ9StgL_v-Z+hpGnbC6Ggu1N3hWXfV_gqUu6caCbcMCtQ@mail.gmail.com>
References: <1327706681-11959-1-git-send-email-wad@chromium.org>
	 <20120127234140.GA19407@suse.de>
	 <CABqD9hZ9StgL_v-Z+hpGnbC6Ggu1N3hWXfV_gqUu6caCbcMCtQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-27 at 17:47 -0600, Will Drewry wrote:

> > Isn't 'struct seccomp_struct' a bit redundant?
> >
> > How about a simple 'struct seccomp' instead?
> 
> Works for me - I can't recall why that seemed to make sense (other
> than the user of similar redundant names elsewhere).
> 

You mean like... struct task_struct?

;-)

-- Steve


