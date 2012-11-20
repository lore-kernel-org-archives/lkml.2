Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab2KTLFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 06:05:48 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:19524 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab2KTLFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 06:05:46 -0500
X-AuditID: cbfee610-b7fd06d000005bdb-bd-50ab640814af
Date: Tue, 20 Nov 2012 11:05:44 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCH] extcon : callback function to read cable property
To: Anton Vorontsov <cbouatmailru@gmail.com>, "Tc, Jenny" <jenny.tc@intel.com>
Cc: =?euc-kr?Q?=C3=D6=C2=F9=BF=EC?= <cw00.choi@samsung.com>,
        anish singh <anish198519851985@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "myunjoo.ham@gmail.com" <myunjoo.ham@gmail.com>,
        "lockwood@android.com" <lockwood@android.com>,
        "peterhuewe@gmx.de" <peterhuewe@gmx.de>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "lars@metafoo.de" <lars@metafoo.de>,
        "jic23@kernel.org" <jic23@kernel.org>,
        "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20121120110536337@myungjoo.ham
Msgkey: 20121120110536337@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20121120110536337@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <32212704.282601353409543335.JavaMail.weblogic@epml17>
DLP-Filter: Pass
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsVy+t8zTV3OlNUBBrvOsFhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M06eushWcEKnY/ncLSwNjg0gXIyeHkIC6xKIlJ9lAbAkBE4mV
	JzYzQ9hiEhfurQeKcwHVLGOUuPWtkRmm6FzrYhaIxHxGiQdTOsC6WQRUJXYd/craxcjBwSag
	JzHzczJIWFjAS+LHwvVgJSICQRK9UxezgvQyC1xikfh0fjkjxBVKEmv2vWIBsXkFBCVOznzC
	ArFMVWLdtBPMIDN5BdQkfn3XhAhLSMyafoEVwuaVmNH+FKpcTmLa1zVQd0pLnJ+1gRHmmcXf
	H0PF+SWO3d7BBDISpPfJ/WCYMbs3f4GGg4DE1DMHoVq1JDaemwAV55NYs/AtC8yYXaeWM8P0
	3t8ylwnEZhZQlJjS/ZAdwtaS+PJjHxu6r3gFnCQmdF5knsCoPAtJahaS9llI2pHVLGBkWcUo
	mlqQXFCclJ5qplecmFtcmpeul5yfu4kRkhYEdjAuabA4xCjAwajEw/swYVWAEGtiWXFl7iFG
	CQ5mJRFep4DVAUK8KYmVValF+fFFpTmpxYcYfYDxN5FZSjQ5H5iy8kriDY0NjA0NLQ3NTC1N
	DXAIK4nzsldMDxASSE8sSc1OTS1ILYIZx8TBKdXAqHPfb9/ChDVTbSS1/Gqa753obpW9PN3Z
	5XKdnXTCqjV2t2fOsbU5N71Hg3uK3/JdgWcCrvu3ua1wtj7tKebZp/OLP7vXa8/3j+v8/ljV
	trf1L1trF3qw+a1Kc3OfTGDvopPl2ifaNlwO2s3WZOW6elJo2q5m7UlnZZ+8nhJzxkgvpe/P
	6rJjSizFGYmGWsxFxYkAIkiG6TgDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFKsWRmVeSWpSXmKPExsVy+t/tGbocKasDDI68srK4vGsOmwOjx+dN
	cgGMURk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StFGBsZ6RqYmekbGBnomBrFWhgYGRqZAVQkZ
	GadPXWUrOCFSsf3vFpYGxgaRLkZODiEBdYlFS06ygdgSAiYS51oXs0DYYhIX7q0HinMB1cxn
	lHgwpQOsiEVAVWLX0a+sXYwcHGwCehIzPyeDhIUFvCR+LFwPViIiECTRO3UxK0gvs8AlFolP
	55czQixTkliz7xXYAl4BQYmTM59ALVOVWDftBDPITF4BNYlf3zUhwhISs6ZfYIWweSVmtD+F
	KpeTmPZ1DTOELS1xftYGRpibF39/DBXnlzh2ewcTyEiQ3if3g2HG7N78BepdAYmpZw5CtWpJ
	bDw3ASrOJ7Fm4VsWmDG7Ti1nhum9v2UuE4jNLKAoMaX7ITuErSXx5cc+NnRf8Qo4SUzovMg8
	gVFuFpLULCTts5C0I6tZwMiyilE0tSC5oDgpPdVMrzgxt7g0L10vOT93EyM4QT0T2MG4pMHi
	EKMAB6MSD+/DhFUBQqyJZcWVuYcYJTiYlUR4nQJWBwjxpiRWVqUW5ccXleakFh9i9AHG30Rm
	KdHkfGDyzCuJNzQ2MDY0tDQ3MDU0ssAhrCTOy14xPUBIID2xJDU7NbUgtQhmHBMHp1QDI/ve
	mPx71ZMire++s8i+emfW/pxOwT0LeuWWPGe++S3mTUua2co5Zs9vRtsu/jG91W7pY/awezen
	SITw8ExOP9P68u1Rk28WdS90BWXCfj0L8RWbXyC44hVniEbGcbPkOqUud7VL9ZujFIzfVnAV
	KifpNsQ+2cbx1t5Q31bJWcDY8dsJ/8jnSizFGYmGWsxFxYkAk4sdzH0DAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qAKB5qCk021254

Anton Vorontsov wrote:
> The idea of using union seemed good to me, what happened to it?
> 
> I mean, MyungJoo Ham wrote:
> 
> | We may have:
> |        enum extcon_cable_type {
> |                EXTCON_CT_REGULATOR,
> |                EXTCON_CT_PSY,
> |                EXTCON_CT_CHARGER_CB,
> |                ...
> |        };
> | and have the following included at struct extcon_cable:
> |        union {
> |                struct regulator *reg;
> |                struct power_supply *psy;
> |                struct charger_cable *charger_cb;
> |                ...
> |        } cable data;
> |        enum extcon_cable_type cable_type;
> 
> This sounds good to me...
> 
> >  * extcon is not designed to support any cable state other than CONNECT/DISCONNECT
> 
> Dunno for this one. Can we get these additional states via "properties" as
> described above?
> 
> Thanks,
> Anton.
> 
> 


The "RFC" patch for this feature is now shown at:
http://git.kernel.org/?p=linux/kernel/git/mzx/extcon.git;a=commit;h=5655aeef83addaec77a3b9387a3dd18b6c146dd5
(Note that "for-add-feature" branch is sort of "RFC" branch)

I'm now considering relaying notifications of data updates possible via
the notifier block of register-interest. Any inputs are welcomed.


Anyway, for the USB issue of "suspend/resume at host-side and current-limit at
device-side", we will need to
1. update regulator subsystem to have notification for current change
(it does for enable/disable/voltage-changes)
2. let the charger use current-regulator
3. let the one who detects (usb driver?) changes at host-side change the
current limit of that current-regulator
4. let the event from current-regulator relayed via extcon.
We may use power-supply class as well for this issue. (may need to update
if power-supply class does not have notifications and suspend/resume states)


Cheers,
MyungJoo

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
