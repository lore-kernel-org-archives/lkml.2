Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141Ab1ALSFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 13:05:35 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:21364 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755497Ab1ALSFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 13:05:32 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: lq9sxKUVM1kTLKeVWaNMchUGb6EoXkytoA0WO1ysxyQqini
 vyav.skzz8Urbjcyw.S5odStWgB6rcpCnbzK8HcYoAbPaNbEQPBW.l8pjVwl
 RCEe.vVREb71ZI9fb1U07fjeF5.ewfE8euSyY68b9dLH0B1y21QmgGqibnTA
 EKockpV5mXqFv7qICdjk0sgKtoWh3Y1xg.hqI.L2V9ZpLI5lS573luujvUNB
 SvInMGQBGsB9ciJN5uSpnV6Rfx4U5ASdTeydKE8q0kvSF_YxKFCgwboBcI0.
 a.kv9A0dopNtyh3OMa93xIEpSX4UmSsrinfyXbZOZ8PJKLgrPtzc-
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 12 Jan 2011 12:05:27 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric B Munson <emunson@mgebm.net>
cc: akpm@linux-foundation.org, linux-mm@kvack.org, mel@csn.ul.ie,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Rename struct task variables from p to tsk
In-Reply-To: <1294845571-11529-1-git-send-email-emunson@mgebm.net>
Message-ID: <alpine.DEB.2.00.1101121205120.3053@router.home>
References: <1294845571-11529-1-git-send-email-emunson@mgebm.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use t instead of p? Its a local variable after all.


