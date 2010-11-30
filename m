Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab0K3TSd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:18:33 -0500
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:44695 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751655Ab0K3TSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:18:32 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: ECRBkPUVM1n.G9umPcmdx_b79nIG625XonmUjrsfkqdqM_2
 bb.w9G_pUlfuogk3qFp4Tj1t4KDf4l5Ku9F1_jU86Kmpn0QIue40cu0vE2yR
 tEE3P0KxkU2P_RegVx0BxmHg_dSJ36DofQvJwAsSDaKz5JZnJiQCw.jLw.1g
 V2fFjTU1MmgiEuwCy1eEZBkO7vSVkkFyMUP_3vAmeKdQcS3cj5iPzl5kMkOk
 1pFqqTHA5ydZv.cVYnkor4iWqHBijxYEZ_qy0.66XsNYtr6aPBEtF3iAX
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 30 Nov 2010 13:18:29 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: linux-mm@kvack.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/3] Move zone_reclaim() outside of CONFIG_NUMA
In-Reply-To: <20101130101506.17475.34536.stgit@localhost6.localdomain6>
Message-ID: <alpine.DEB.2.00.1011301318070.3134@router.home>
References: <20101130101126.17475.18729.stgit@localhost6.localdomain6> <20101130101506.17475.34536.stgit@localhost6.localdomain6>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Reviewed-by: Christoph Lameter <cl@linux.com>


