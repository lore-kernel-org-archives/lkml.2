Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab2FTGQH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 02:16:07 -0400
Received: from serv04.lahn.de ([213.239.197.57]:35450 "EHLO serv04.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658Ab2FTGQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 02:16:05 -0400
Date: Wed, 20 Jun 2012 08:15:53 +0200
From: Michael Leun <lkml20120218@newton.leun.net>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: Mohammed Shafi <shafi.wireless@gmail.com>,
        <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: ath9k_htc: Every 2nd packet 1000ms delayed in recent kernels
Message-ID: <20120620081553.040171f4@xenia.leun.net>
In-Reply-To: <20120620061303.GA8738@vmraj-lnx.qca.qualcomm.com>
References: <20120619085137.337838c0@xenia.leun.net>
	<CAD2nsn1b6in_yA1b+o=SoXD3iJPddoF4PeCQ3qhFNWqfZxq8pQ@mail.gmail.com>
	<20120620003315.2eaf6460@xenia.leun.net>
	<20120620061303.GA8738@vmraj-lnx.qca.qualcomm.com>
Organization: Not Organized
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2012 11:43:05 +0530
Rajkumar Manoharan <rmanohar@qca.qualcomm.com> wrote:


> Thanks for the analysis. Can you please try with the attached patch
> without reverting mac80211 change?

Radio Eriwan answers: In principle yes, but you forgot the
attachment ;-)

-- 
MfG,

Michael Leun

