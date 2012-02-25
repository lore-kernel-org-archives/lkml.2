Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab2BYMUf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 07:20:35 -0500
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:64589 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751962Ab2BYMUd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 07:20:33 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Feb 2012 07:20:33 EST
X-AuditID: 12074424-b7fae6d000000906-46-4f48d0e4a3d6
Subject: Re: Can we move device drivers into user-space?
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=windows-1252
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <20120224221459.GA5254@polaris.bitmath.org>
Date: Sat, 25 Feb 2012 07:15:29 -0500
Cc: Theodore Tso <tytso@MIT.EDU>, Greg KH <gregkh@linuxfoundation.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Jidong Xiao <jidong.xiao@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <717014CA-C53C-4001-BD60-B742468DA0BD@MIT.EDU>
References: <20120224171752.GB9485@kroah.com> <20120224183423.GA23284@kroah.com> <20120224191535.GA4505@polaris.bitmath.org> <20120224192643.GB24120@kroah.com> <20120224201027.GA4859@polaris.bitmath.org> <20120224201655.GA5994@kroah.com> <20120224203715.GA4995@polaris.bitmath.org> <20120224205651.GA13333@kroah.com> <20120224212238.GA5178@polaris.bitmath.org> <20120224213027.GB15735@thunk.org> <20120224221459.GA5254@polaris.bitmath.org>
To: "Henrik Rydberg" <rydberg@euromail.se>
X-Mailer: Apple Mail (2.1257)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsUixCmqrfvkgoe/wapbchbNi9ezWcyd3M1i
	cXffdlaLy7vmsFlMmT6T0YHV49fXq2weBybfZPPYOesuu8f+uWvYPT5vkgtgjeKySUnNySxL
	LdK3S+DKmHH1MnvBFbaKqYvnsDQwzmDtYuTkkBAwkThydhYThC0mceHeerYuRi4OIYF9jBJL
	vh5hgXA2MEq8+tXFBlIlJHCaSeLZ0yoQW1jAQuLIv+OMIDavgKHEzFftYFOZBfQkdlz/BWaz
	CShJ3Pm0nwXE5gSqfzzhBFicRUBVYvr9zWDbmAVeMUr8XdjNDNGsLbFs4WtmiKFWEm/nzGCE
	WLydWWJyeySILSKgJXFtzjl2iLNlJW4f3M80gVFwFpI7ZiG5YxaSsQsYmVcxyqbkVunmJmbm
	FKcm6xYnJ+blpRbpmuvlZpbopaaUbmIEBT+7i8oOxuZDSocYBTgYlXh4I7e5+wuxJpYVV+Ye
	YpTkYFIS5eUCxo4QX1J+SmVGYnFGfFFpTmrxIUYJDmYlEV47NqAcb0piZVVqUT5MSpqDRUmc
	V0PrnZ+QQHpiSWp2ampBahFMVoaDQ0mCNxRkqGBRanpqRVpmTglCmomDE2Q4D9DwCpAa3uKC
	xNzizHSI/ClGRSlxXkeQhABIIqM0D64XlpxeMYoDvSLMGwlSxQNMbHDdwPAH+kiE1/6vK8jg
	kkSElFQDY/ADCW9fwy/X15ianthQdXpBo9XhT5NF7nP8e2HN3NQmuWwnxxGf7489U/kmmTBe
	Ffwf8bNtjvbWh59+s/w7datjbsKx1arzaw8Yrb8V/+DLr8sJuZ1cq1I9Aw2W//L7MqGv3puX
	Yc1LsdeXb2e+YfGwsjvePNlfXu//jyittktb+r+on7jgW6bEUpyRaKjFXFScCAC6MSHVKQMA
	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 24, 2012, at 5:14 PM, Henrik Rydberg wrote:

> True, and the emergent interface (vfs) is even accessible in
> userspace, so all is good in that department for now. Conversely, you
> have not shown that this can go on forever. ;-)

… and the performance is terrible --- as it must be.  If you don't understand why this must be, then we're wasting our time having this conversation.

And if you're the one wanting to make a change, then you are the one who has to provide the proof.   Otherwise we're just talking about hypotheticals, and that way lies over-design.  Why waste time engineering something that may never come to pass?

Of course, your time is something you are free to spend however you like.  So if you want to try implementing some of these grand plans of yours, show us the code….

-- Ted

