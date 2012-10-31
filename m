Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933787Ab2JaCLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 22:11:17 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48318 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab2JaCLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 22:11:15 -0400
X-AuditID: cbfee60c-b7fb06d00000355f-b7-509088bdd0f8
Date: Wed, 31 Oct 2012 02:11:09 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: Re: [for-next PATCH V2] PM / devfreq: Add sysfs node to expose
 available frequencies
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Nishanth Menon <nm@ti.com>, linux-pm <linux-pm@vger.kernel.org>,
        Rajagopal Venkat <rajagopal.venkat@linaro.org>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        Kevin Hilman <khilman@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20121031020552074@myungjoo.ham
Msgkey: 20121031020552074@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20121031020552074@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <3578820.552041351649466344.JavaMail.weblogic@epv6ml03>
DLP-Filter: Pass
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsVy+t8zPd29HRMCDD5OkrW4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZr95tYyz4wF+x890k9gbGHfxdjJwcQgLqEouWnGQDsSUETCTu
	bj/EAmGLSVy4tx4ozgVUM4tR4vPJBYwwRWc2PWWESMxnlFjW/A6sm0VAVeLluTXMXYwcHGwC
	ehIzPyeDhIUFEiUW3DgP1isCVLLlyX92kF5mgUVMEmdv/WOGuEJJYs2+V2CbeQUEJU7OfAJ1
	harEhW3XWSHiahJLd92CiktIzJp+gRXC5pWY0f4UKi4nMe3rGmYIW1ri/KwNjDDfLP7+GCrO
	L3Hs9g4mkDtBep/cD4YZs3vzF2hACEhMPXOQEaJES6JlohVEmE9izcK3LDBTdp1azgzTen/L
	XCYQm1lAUWJK90N2CFtL4suPfWzovuIVcJb4t6iLeQKj8iwkqVlI2mchaUdWs4CRZRWjaGpB
	ckFxUnqqkV5xYm5xaV66XnJ+7iZGSFrg2cE4p8HiEKMAB6MSD6/Bv/4AIdbEsuLK3EOMEhzM
	SiK8FzMmBAjxpiRWVqUW5ccXleakFh9i9AHG30RmKdHkfGDKyiuJNzQ2MDY0tDQ0M7U0NcAh
	rCTOW+eREiAkkJ5YkpqdmlqQWgQzjomDU6qB0e3s8h8M9YWO7WmysUrnu5mnak9YbCO338b3
	xdxr+49WSkkWzdB7ILMu8/mMJEs70RBF3SA15s1M788zMe/j3XRIbfuE56pih+1CyybXG6qz
	20Y0Nf0x2sccGvnjft55UcFfry4lhB07I/RU8edqt0N3vzyMqYsoZpaIOW9nYC4cxFqX/51X
	iaU4I9FQi7moOBEAFsD9ZTgDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFKsWRmVeSWpSXmKPExsVy+t/t6bp7OyYEGMz4LmFxedccNgdGj8+b
	5AIYozJsMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CG
	KimUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslaKNDIz1jExN9IyMDfRMDGKtDA0MjEyBqhIy
	Ml6928ZY8IG/Yue7SewNjDv4uxg5OYQE1CUWLTnJBmJLCJhInNn0lBHCFpO4cG89UJwLqGY+
	o8Sy5ndgRSwCqhIvz61h7mLk4GAT0JOY+TkZJCwskCix4MZ5sF4RoJItT/6zg/QyCyxikjh7
	6x8zxDIliTX7XrGA2LwCghInZz5hgVimKnFh23VWiLiaxNJdt6DiEhKzpl9ghbB5JWa0P4WK
	y0lM+7qGGcKWljg/awPc0Yu/P4aK80scu72DCeROkN4n94Nhxuze/AXqXwGJqWcOMkKUaEm0
	TLSCCPNJrFn4lgVmyq5Ty5lhWu9vmcsEYjMLKEpM6X7IDmFrSXz5sY8N3Ve8As4S/xZ1MU9g
	lJuFJDULSfssJO3IahYwsqxiFE0tSC4oTkpPNdIrTswtLs1L10vOz93ECE5Qz3h2MM5psDjE
	KMDBqMTDa/CvP0CINbGsuDL3EKMEB7OSCO/FjAkBQrwpiZVVqUX58UWlOanFhxh9gPE3kVlK
	NDkfmDzzSuINjQ2MDQ0tzQ1MDY0scAgrifPWeaQECAmkJ5akZqemFqQWwYxj4uCUamDUbz1x
	SU/tiYuORUxcncXho3paq5c4Rs5K51wgx7rg6+1r/OWdd2ft+uxddO3P9U2Ohcw2C4/n8lYp
	Xd5ZUSe3q8V6Z8m72TPOxRy5YL6Zz+H1/ppziYn6wTsTu6fcs7R+O0/xkWjetdMB/fos+YsF
	WxgO5MXq7C/Lzig5l6AXJ3b3k+sZCxklluKMREMt5qLiRABYKPh/fQMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9V2BMKi015998

> On Friday, October 26, 2012 06:16:36 AM MyungJoo Ham wrote:
> > > devfreq governors such as ondemand are controlled by a min and
> > > max frequency, while governors like userspace governor allow us
> > > to set a specific frequency.
> > > However, for the same specific device, depending on the SoC, the
> > > available frequencies can vary.
> > > 
> > > So expose the available frequencies as a snapshot over sysfs to
> > > allow informed decisions.
> > > 
> > > This was inspired by cpufreq framework's equivalent for similar
> > > usage sysfs node: scaling_available_frequencies.
> > > 
> > > Cc: Rajagopal Venkat <rajagopal.venkat@linaro.org>
> > > Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
> > > Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > > Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> > > Cc: Kevin Hilman <khilman@ti.com>
> > > Cc: linux-pm@vger.kernel.org
> > > Cc: linux-kernel@vger.kernel.org
> > > 
> > > Signed-off-by: Nishanth Menon <nm@ti.com>
> > 
> > Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> 
> Are you going to handle this patch?

Yes, I've just setup the git repository this week
and I'm willing to handle this one.

It is applied at
http://git.kernel.org/?p=linux/kernel/git/mzx/devfreq.git;a=shortlog;h=refs/heads/for-rafael

Thanks,

MyungJoo

> 
> Rafael
> 
> 
> -- 
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
> 
> 
> 
>        
>   
>          
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
