Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab2LUDjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 22:39:11 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:33945 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab2LUDjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 22:39:02 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-3d-50d3d9d470d3
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        "'Olof Johansson'" <olof@lixom.net>, "'Arnd Bergmann'" <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Axel Lin'" <axel.lin@ingics.com>,
        "'Linus Walleij'" <linus.walleij@linaro.org>
References: <20121221132014.0bf8772fb3e48c51cec1548a@canb.auug.org.au>
In-reply-to: <20121221132014.0bf8772fb3e48c51cec1548a@canb.auug.org.au>
Subject: RE: linux-next: manual merge of the arm-soc tree with the pinctrl tree
Date: Thu, 20 Dec 2012 19:38:53 -0800
Message-id: <027101cddf2c$b4f2f9b0$1ed8ed10$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQFHHic3Snc8rUaPJRp6M9YygXC2pJkwGzIA
Content-language: en-us
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t8zA90rNy8HGNz+ym5xedccNouDC9sY
	HZg8Pm+SC2CM4rJJSc3JLEst0rdL4Mp427qeteAtW8Xp+ceYGhi3sXYxcnJICJhIbH81lw3C
	FpO4cG89kM3FISSwjFHi5cS7jDBFZ7s7GSES0xklXm/fzwTh/GWUeD7lNFg7m4CGxOH3z9hB
	EiICsxkl/r/8D1bFLNDDKDHpx1kWkCohATeJrvuvwOZyCrhL7OzpYO5i5OAQFvCXmPBSHSTM
	IqAq8WndIbChvAKWEu+/bmGGsAUlfky+BzaGWUBLYv3O40wQtrzE5jVvmSFOVZDYcfY12HgR
	ASOJpZ/nQdWLS0x68JAdYr6AxLfJh1hA1koIyEpsOsAMcqaEwDp2iYVv5kO9LClxcMUNlgmM
	ErOQrJ6FZPUsJKtnIVmxgJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZIpEntYFzZYHGI
	UYCDUYmHl9HscoAQa2JZcWXuIUYJDmYlEd7nS4BCvCmJlVWpRfnxRaU5qcWHGH2ALp/ILCWa
	nA9MAnkl8YbGxiZmJqYm5pam5qY4hJXEeZs9UgKEBNITS1KzU1MLUotgxjFxcEo1MPLsM4wV
	T3aLWPech/FNSvnLqmmvajZcclnfMb1TeFcf4/ofVp/yfn+bu/zLhlfzlzuJn3TvW7nA9l9r
	wuam78rTJHkYlKXc0/u1XY35mQMa4ivEP/mdrLvQalNu2mru236pz0ehUu2H0W7J0udW0TfF
	V1Y7PelwyeC2+xJXK5h+m+v54p8FSizFGYmGWsxFxYkAcvPOQ+ECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t9jQd0rNy8HGLw+xmxxedccNouDC9sY
	HZg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMeNu6nrXgLVvF
	6fnHmBoYt7F2MXJySAiYSJzt7mSEsMUkLtxbz9bFyMUhJDCdUeL19v1MEM5fRonnU06zgVSx
	CWhIHH7/jB0kISIwm1Hi/8v/YFXMAj2MEpN+nGUBqRIScJPouv8KbC6ngLvEzp4O5i5GDg5h
	AX+JCS/VQcIsAqoSn9YdAhvKK2Ap8f7rFmYIW1Dix+R7YGOYBbQk1u88zgRhy0tsXvOWGeJU
	BYkdZ1+DjRcRMJJY+nkeVL24xKQHD9knMArNQjJqFpJRs5CMmoWkZQEjyypG0dSC5ILipPRc
	Q73ixNzi0rx0veT83E2M4Dh+JrWDcWWDxSFGAQ5GJR5eRrPLAUKsiWXFlbmHGCU4mJVEeJ8v
	AQrxpiRWVqUW5ccXleakFh9i9AH6dCKzlGhyPjDF5JXEGxqbmBlZGplZGJmYm+MQVhLnbfZI
	CRASSE8sSc1OTS1ILYIZx8TBKdXAKCYfKnT81bVt0v6uYjtlMzo0Ux7MCOyqYvgl4JrL7dTe
	ekZr/gHnp5VHVfjDtLbVzTu+ZvWVd/sObJX+b/oweVcUM8+z7C+7/lot+sHWdnSS0GsdoZCb
	cau6GC97nD6u+uZHpv6klktb9pwL9k2L+/pvyeRjS8u3num/oeWeeb1Lla3zyY7M/UosxRmJ
	hlrMRcWJABDd2bkQAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> 
> Hi all,
> 
> Today's linux-next merge of the arm-soc tree got conflicts in
> drivers/pinctrl/pinctrl-exynos5440.c and
> drivers/pinctrl/pinctrl-samsung.c between commit e5b4c9d4ab55 ("pinctrl:
> exynos5440: Fix compile error in pinctrl-exynos5440/samsung.c") from the
> pinctrl tree and commit d5fd5da290ce ("pinctrl: exynos5440/samsung:
> Staticize pcfgs") from the arm-soc tree.
> 
Oops, the commit d5fd5da290ce already sent to Linus Torvalds via arm-soc
tree today. In addition, I applied with Linus Walleij's ack ;-)

Linus Walleij, please drop the patch in your tree. Sorry I didn't notify
about that when I got the patch from Choi.

Thanks.

- Kukjin

> The former is a superset of the latter, so I used that (no action
> is required).
> 
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au

