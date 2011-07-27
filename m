Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab1G0Q7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 12:59:35 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:16524 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754903Ab1G0Q7d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 12:59:33 -0400
Date: Wed, 27 Jul 2011 12:58:45 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: jeremy@goop.org, xen-devel@lists.xensource.com, x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, keir.xen@gmail.com
Subject: Re: [Xen-devel] Re: [PATCH 0/5] Collected vdso/vsyscall fixes for 3.1
Message-ID: <20110727165844.GA8064@dumpdata.com>
References: <cover.1311736366.git.luto@mit.edu>
 <20110727145745.GA11872@dumpdata.com>
 <CAObL_7FT8QLg-wihasBahhAtS=pA7+KeU8E=E9x8NPZ0+QJ5iQ@mail.gmail.com>
 <20110727153015.GA16688@dumpdata.com>
 <CAObL_7GWGx4rYJFLpucEX=ozNpk+5ipyq0=vw16xcGetEXSuGQ@mail.gmail.com>
 <20110727154316.GA16909@dumpdata.com>
 <CAObL_7FncQ7DdNf2igFZW=ZzPFQLO3Vvp1c_y5EajA_KTt8iOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <CAObL_7FncQ7DdNf2igFZW=ZzPFQLO3Vvp1c_y5EajA_KTt8iOg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4E3043D2.0078:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> $ test_vsyscall test
> >> Testing gettimeofday...
> >>   vDSO offset = 0.000001s
> >>   vsyscall offset = 0.000001s
> >>
> >> Testing time...
> >>   vDSO offset = 0
> >>   vsyscall offset = 0
> >> Testing getcpu...
> >>   ok!  cpu=6 node=0

> I bet if you pull a new copy or remove -mavx from Makefile it will
> work.  I got a grossly hacked-up Xen domU booted and everything seems
> to work.

It did. Both Dom0 and DomU work on AMD and Intel.

In regards to the last pv-ops patch - is there no better way? The reason I am asking
is the pv-ops hook is just a bandaid for the problem. Is the Xen syscall suppose to
be doingsomething extra with the stack perhaps?
