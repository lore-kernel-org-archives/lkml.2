Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257Ab1KHLZy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 06:25:54 -0500
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:49397 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755507Ab1KHLZw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 06:25:52 -0500
X-AuditID: 12074424-b7ef76d0000008dc-4b-4eb911bff4f4
Subject: Re: [F.A.Q.] perf ABI backwards and forwards compatibility
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <alpine.LFD.2.02.1111081317160.18135@tux.localdomain>
Date: Tue, 8 Nov 2011 06:25:43 -0500
Cc: Theodore Tso <tytso@MIT.EDU>, Ingo Molnar <mingo@elte.hu>,
        "Frank Ch. Eigler" <fche@redhat.com>, Vince Weaver <vince@deater.net>,
        Pekka Enberg <penberg@kernel.org>,
        Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?iso-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <924C4E60-08C9-45A1-B0F3-5717BC295726@MIT.EDU>
References: <20111106183132.GA4500@thunk.org> <CAOJsxLHvYo5zA+_m-AXuZHjAcGKE5q0ytmPCZ0Gye52LWq1p9Q@mail.gmail.com> <CAOJsxLG6kyq-RoQiBj0B_tThvOy1AxJf6XB2VfQFQJkwQ5cHcQ@mail.gmail.com> <20111106231953.GD4500@thunk.org> <alpine.LFD.2.02.1111070838520.1823@tux.localdomain> <alpine.DEB.2.02.1111071156230.28615@pianoman.cluster.toy> <20111107175942.GA9395@elte.hu> <y0mpqh3og3v.fsf@fche.csb> <alpine.LFD.2.02.1111072204370.3082@tux.localdomain> <20111107203514.GG24234@thunk.org> <20111108102235.GA1241@elte.hu> <F1D0EDA6-8D93-4FF8-BF3D-F8D02702E74F@mit.edu> <alpine.LFD.2.02.1111081317160.18135@tux.localdomain>
To: Pekka Enberg <penberg@cs.helsinki.fi>
X-Mailer: Apple Mail (2.1251.1)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJKsWRmVeSWpSXmKPExsUixCmqrbtfcKefwaEWA4uLbRfZLA52X2ez
	OHHlH6PFnIfPWC223PnMZnHrnoDF5Z9MFnOmFlpc3jWHzWLLpWZWiwcrL7BZtH3+x2pxvHcH
	i8WjvrfsFm8e72ezWLWhi9FBwOPKUw6PqRePMHqsvWbh0XJC0+NW2x9mj52z7rJ7bFrVyeZx
	YsZvFo8n1zYzebzfd5XNY/Ppao/Pm+QCeKK4bFJSczLLUov07RK4MjY+lytoZK14feYkUwPj
	N+YuRk4OCQETifOXp7FB2GISF+6tB7K5OIQE9jFK/Dr3GcpZzyixYtIlVgjnFJPEuf2LWUBa
	hAWcJfpvzgWzeQWMJdbcegdmMwtoSdz495IJxGYTUJK482k/WJxTwEni5YNFYKtZBFQk1vfO
	ZwcZyizwk1Vi9v3j7BDN2hLLFr5mhhhqJfH9wGxWEFtI4CGLxI4fiSC2iICmxMrWRkaIu+Ul
	Wr7eYZvAKDgLyR2zkNwxC8nYBYzMqxhlU3KrdHMTM3OKU5N1i5MT8/JSi3TN9XIzS/RSU0o3
	MYJilN1FZQdj8yGlQ4wCHIxKPLwzRXf4CbEmlhVX5h5ilORgUhLlvcaz00+ILyk/pTIjsTgj
	vqg0J7X4EKMEB7OSCK9SE1A5b0piZVVqUT5MSpqDRUmc12ang5+QQHpiSWp2ampBahFMVoaD
	Q0mC1wGYioQEi1LTUyvSMnNKENJMHJwgw3mAhguA1PAWFyTmFmemQ+RPMSpKifNqgiQEQBIZ
	pXlwvbAU+opRHOgVYd7/AkBVPMD0C9f9CmgwE9Dgdt1tIINLEhFSUg2MmTvF1/6yF/fKP1/t
	Fd216Qinwu59mll33G5JaO6b81tIUHdSjF2Emupn9dA9mbXs+4/6Fr/Ktr5TuE3Ik9V6nu9c
	qS9VV0OPGMwSyAj/qSkitO35x3V3eS+uvuG13Pruhe+3b1ZrqVx47/+jR4O5Z9oUWaXDHTtV
	si8UCGqJXzucMX/FPh0ZJZbijERDLeai4kQApa3ifXwDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 8, 2011, at 6:20 AM, Pekka Enberg wrote:

> We have the staging tree because it's a widely acknowledged belief that kernel code in the tree tends to improve over time compared to code that's sitting out of the tree. Are you disputing that belief?

Kernel code in the kernel source tree improves; because that's where it will eventually end up --- linked against the kernel.

There are all sorts of dynamics in play that don't necessarily apply to userspace code.

Otherwise we could just link in all of the userspace code in a Linux distribution and magically expect it will get better, eh?   Not!

-- Ted

