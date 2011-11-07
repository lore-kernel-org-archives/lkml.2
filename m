Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab1KGXr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 18:47:59 -0500
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:53435 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751768Ab1KGXr6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 18:47:58 -0500
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Nov 2011 18:47:57 EST
X-AuditID: 12074423-b7f756d0000008d0-7d-4eb86d00fdf3
Subject: Re: [Qemu-devel] [PATCH] KVM: Add wrapper script around QEMU to test kernels
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=US-ASCII
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <4EB85969.2010108@codemonkey.ws>
Date: Mon, 7 Nov 2011 18:42:47 -0500
Cc: Theodore Tso <tytso@MIT.EDU>, Pekka Enberg <penberg@kernel.org>,
        Vince Weaver <vince@deater.net>, Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?iso-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Transfer-Encoding: 7BIT
Message-Id: <12F471C8-2CF3-4CD7-B417-C8CC898669E6@mit.edu>
References: <CAOJsxLFGAnNL9uA=WHD8eJVs5V2+BSrtC+3ff2FsPi326dtjZw@mail.gmail.com>	<4EB6BAED.2030400@redhat.com>	<4EB6BEFA.6000303@codemonkey.ws>	<20111106183132.GA4500@thunk.org>	<CAOJsxLHvYo5zA+_m-AXuZHjAcGKE5q0ytmPCZ0Gye52LWq1p9Q@mail.gmail.com>	<CAOJsxLG6kyq-RoQiBj0B_tThvOy1AxJf6XB2VfQFQJkwQ5cHcQ@mail.gmail.com>	<20111106231953.GD4500@thunk.org>	<alpine.LFD.2.02.1111070838520.1823@tux.localdomain>	<alpine.DEB.2.02.1111071156230.28615@pianoman.cluster.toy>	<CAOJsxLEfapPPU8cEfeCMq9_oG6858YzFS_fkWQEo_fxs+xde9A@mail.gmail.com>	<20111107203255.GF24234@thunk.org> <CAOJsxLEKx5M5L_N42pQpo2hcNhseQKhUo6CXAyQHesJRWFASKQ@mail.gmail.com> <4EB85969.2010108@codemonkey.ws>
To: Anthony Liguori <anthony@codemonkey.ws>
X-Mailer: Apple Mail (2.1251.1)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLKsWRmVeSWpSXmKPExsUixG6nrsuQu8PPYEmfiMWJK/8YLeY8fMZq
	seXOZzaLW/cELOZMLbS4vGsOm8WWS82sFm2f/7FaHO/dwWLxqO8tu8Wbx/vZLFZt6GJ04PGY
	evEIo0fLCU2PW21/mD12zrrL7rFpVSebx4kZv1k8nlzbzOTxft9VNo/Np6s9Pm+SC+CK4rJJ
	Sc3JLEst0rdL4Mo42WlS8IS14sGcAywNjEdZuhg5OCQETCS6fup1MXICmWISF+6tZ+ti5OIQ
	EtjHKLF/cQsLhLOeUeLIg3mMEM5RJokFjVsZQVqEBUIlTq28xAZi8woYS6y59Y4FxGYW0JHY
	ufUOWJxNQEnizqf9YHFOAV2J/we+M4JsZhFQkfj+uBpkJrPALhaJZ0cWMEH0akssW/iaGWKm
	lcSkifvYIRbPZpXoOPsULCECVPRg80ZGiLvlJVq+3mGbwCg4C8kds5DcMQvJ3AWMzKsYZVNy
	q3RzEzNzilOTdYuTE/PyUot0zfRyM0v0UlNKNzGCY81FeQfjn4NKhxgFOBiVeHhniu7wE2JN
	LCuuzD3EKMnBpCTKOzcDKMSXlJ9SmZFYnBFfVJqTWnyIUYKDWUmEVyQUKMebklhZlVqUD5OS
	5mBREueV2engJySQnliSmp2aWpBaBJOV4eBQkuBNyAFqFCxKTU+tSMvMKUFIM3FwggznARre
	nwoyvLggMbc4Mx0if4pRUUqcNx2kWQAkkVGaB9cLS4WvGMWBXhHmtUwGquIBplG47ldAg5mA
	BrfrbgMZXJKIkJJqYKzz9p6SEB7AOcs2KIXroEnvZ7vvbaujJoQoaHHmTWOytpp0U8JgZalv
	qaJD6aXDTgV3KxL8zb4wR5hrnj2n0llwtsVybSvv6Rijj56XJwteOvyyhk+wdlWT522v2dyX
	TQPjhHP/ZE2+WFGy6cenm3PUn4fG7G+7e2HF3q27by9KZq40Xp0WrMRSnJFoqMVcVJwIAJyc
	36lgAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 7, 2011, at 5:19 PM, Anthony Liguori wrote:

> 
> The kernel ecosystem does not have to be limited to linux.git.  There could be a process to be a "kernel.org project" for projects that fit a certain set of criteria.  These projects could all share the Linux kernel release cadence and have a kernel maintainer as a sponsor or something like that.
> 
> That is something that could potentially benefit things like e2fs-tools and all of the other tools that are tied closely to the kernel.

We have that already.   Packages such as e2fsprogs, xfsprogs, xfstests, sparse, git, etc., have git trees under git.kernel.org.  And I agree that's the perfect place for kvm-tool and perf.   :-)

-- Ted

