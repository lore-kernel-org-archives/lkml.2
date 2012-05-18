Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965Ab2ERQwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:52:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45863 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932891Ab2ERQv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:51:56 -0400
Message-ID: <4FB67E20.6080300@zytor.com>
Date: Fri, 18 May 2012 09:51:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: "H.J. Lu" <hjl.tools@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Subject: Re: Urgent: x86-32 and GNU ld 2.22.52.0.1
References: <4FB67146.9080804@zytor.com> <CAMe9rOqp5AUNL7Oeb2fz=nFq6Z-=hdFg_T2kc+jwkYtzOKJv9g@mail.gmail.com> <CAMe9rOp-UoQFBvvorZA8-jBXk5JobkVa+trUH7ihHLxNyqMuWw@mail.gmail.com> <4FB67697.50904@zytor.com> <CAMe9rOqAJGemCiAebtYczqvV62J_cyZcZDDtkFZyLHPKZg1xqQ@mail.gmail.com> <4FB67CD6.8040103@zytor.com> <CAMe9rOpUoj_1TM0NOqVX31aHEez3_i9v6f7_zkGeM8SZ+XDxyQ@mail.gmail.com>
In-Reply-To: <CAMe9rOpUoj_1TM0NOqVX31aHEez3_i9v6f7_zkGeM8SZ+XDxyQ@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2012 09:50 AM, H.J. Lu wrote:
> 
> A small testcase:
> 

Right, but we can equally well just let the postprocessing tool throw an
error.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

