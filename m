Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab1CVVDx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 17:03:53 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:23684 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751099Ab1CVVDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 17:03:51 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: XKqZRTYVM1ncFkJzwFX3rEZdjXt9NsPxYx5Qbc1g1iwB9.P
 6tnoQ6eVdvmc0wVG.zOhvHMqd8Ted26CzUNgOc1PzrxnbYhg3T7yn6Oa9eAI
 BcxP6iVPkzCqSwEMR_riMSsosaKOsE9oFMqdzTThUT6H3lFsRtZMVd0dQNiB
 7CrlYoXbTsPr_4KpIYypMmFakrXdBAOmsMF_Qinn1_vBl2pS4kCjLJ6xgIA.
 seiKTZm9nbwOgKeH5p3QebhFQtaieqvHBfNViM1gG3kKfmApeD9guV42bK09
 yYY7NFi2ry.91Q_pO_yp3eGZMShJWqf5UIVRA7PufNfUWTjg-
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 22 Mar 2011 16:03:48 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mike Frysinger <vapier@gentoo.org>
cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu: cast away printk format warning
In-Reply-To: <1300826388-22881-1-git-send-email-vapier@gentoo.org>
Message-ID: <alpine.DEB.2.00.1103221601010.16870@router.home>
References: <1300826388-22881-1-git-send-email-vapier@gentoo.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Mar 2011, Mike Frysinger wrote:

> So add an explicit cast to unsigned long here.

I believe we have a format character %t to avoid the cast.

