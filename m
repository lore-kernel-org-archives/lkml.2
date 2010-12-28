Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab0L1MXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 07:23:44 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:57085 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab0L1MXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 07:23:43 -0500
X-Greylist: delayed 544 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Dec 2010 07:23:42 EST
X-Spam-ASN: 
From: "Nikita V. Youshchenko" <yoush@cs.msu.su>
To: Mohan V <mohanvforum@gmail.com>
Subject: Re: Drift when measuring time using add_timer
Date: Tue, 28 Dec 2010 15:14:34 +0300
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <AANLkTim4zbBvTyc4hNurCmPN7GisXe1mmzR6P4aj3xzA@mail.gmail.com>
In-Reply-To: <AANLkTim4zbBvTyc4hNurCmPN7GisXe1mmzR6P4aj3xzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201012281514.35179@zigzag.lvk.cs.msu.su>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>            do_gettimeofday(&timeval);

Try getnstimeofday() instead
