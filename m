Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab2HMNdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 09:33:23 -0400
Received: from canardo.mork.no ([148.122.252.1]:55504 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401Ab2HMNdW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 09:33:22 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: KY Srinivasan <kys@microsoft.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Paolo Bonzini <pbonzini@redhat.com>,
        "devel\@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers: hv: use Linux version in guest ID
Organization: m
References: <87fw8mlv7e.fsf@nemi.mork.no>
	<1342771388-24389-1-git-send-email-bjorn@mork.no>
	<20120720152650.GA5201@kroah.com>
	<426367E2313C2449837CD2DE46E7EAF923547836@SN2PRD0310MB382.namprd03.prod.outlook.com>
	<20120720160953.GA5802@kroah.com> <87fw7rhrpv.fsf@nemi.mork.no>
	<426367E2313C2449837CD2DE46E7EAF9236BF42E@SN2PRD0310MB382.namprd03.prod.outlook.com>
Date: Mon, 13 Aug 2012 15:33:05 +0200
In-Reply-To: <426367E2313C2449837CD2DE46E7EAF9236BF42E@SN2PRD0310MB382.namprd03.prod.outlook.com>
	(KY Srinivasan's message of "Mon, 13 Aug 2012 13:04:35 +0000")
Message-ID: <877gt2j4ry.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KY Srinivasan <kys@microsoft.com> writes:

> In the interim, I have submitted a patch that conforms to the MSFT guidelines
> for generating guest IDs for non-MSFT operating systems on Hyper-V.

Oh, sorry.  I missed that.  Found it now.  Thanks

Including distro info in a driver interface looks a bit weird to me, but
I don't really care as long as the previous static value goes away.


Bjørn
