Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333Ab2KBVfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 17:35:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35287 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754935Ab2KBVfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 17:35:17 -0400
Message-ID: <50943C5A.9050106@zytor.com>
Date: Fri, 02 Nov 2012 14:34:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Balbir Singh <bsingharora@gmail.com>
CC: Vivek Goyal <vgoyal@redhat.com>, Matthew Garrett <mjg@redhat.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Khalid Aziz <khalid@gonehiking.org>, kexec@lists.infradead.org,
        horms@verge.net.au, Dave Young <dyoung@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Roberto Sassu <roberto.sassu@polito.it>,
        Kees Cook <keescook@chromium.org>, Peter Jones <pjones@redhat.com>
Subject: Re: Kdump with signed images
References: <20121025185520.GA17995@redhat.com> <1351214158.18115.186.camel@falcor> <20121026023916.GA16762@srcf.ucam.org> <20121026170609.GB24687@redhat.com> <1351276649.18115.217.camel@falcor> <20121101131003.GA14573@redhat.com> <20121101135356.GA15659@redhat.com> <1351780159.15708.17.camel@falcor> <20121101144304.GA15821@redhat.com> <20121101145225.GB10269@srcf.ucam.org> <20121102132318.GA3300@redhat.com> <CAKTCnzkQwhWGJRTiuxv8wp7uPDFoT6eGsN0k51Bvw8=EqQFW=w@mail.gmail.com>
In-Reply-To: <CAKTCnzkQwhWGJRTiuxv8wp7uPDFoT6eGsN0k51Bvw8=EqQFW=w@mail.gmail.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2012 07:29 AM, Balbir Singh wrote:
> 
> Have you seen http://sourceware.org/glibc/wiki/FAQ - "Even statically
> linked programs need some shared libraries which is not acceptable for
> me. What can I do?" Probably, worth trying.
> 

You can build something with klibc... a static klibc binary can easily
be smaller than a dynamic glibc binary.

	-hpa


