Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab1AZQ5B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 11:57:01 -0500
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:29323 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752966Ab1AZQ47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 11:56:59 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: CBjqTDoVM1mfMGimdojmd.vV0YxpjBT5xbKNzQa19JGRmuW
 1bQ1_slGA9HUp8lDWSSkJEzIggQ8cF.EcoRtnhvlhgIU8Sx8PCcWukyIZgOV
 P3N5wPpkJHb6W0_Uv7MgVKeWSM.WGNPerfYBok7KbU_VMbebDKWqmWtat_qY
 uPIc0rOMModbFMMiNM1xZHA6F6XfGWc7NdXaJhl4gvLTQHpzYqbZF4x.KkK6
 y.aQiSRatL81BV_FJaoPWF304I5PKAPUPqrcI4G5qDhYTLmFKy98byOCzjEJ
 a4fc_m_VtVyCiU_mSEa_Xo7HtS9D1AN0_
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 26 Jan 2011 10:56:56 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: linux-mm@kvack.org, akpm@linux-foundation.org, npiggin@kernel.dk,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 1/3] Move zone_reclaim() outside of CONFIG_NUMA (v4)
In-Reply-To: <20110125050430.13141.21260.stgit@localhost6.localdomain6>
Message-ID: <alpine.DEB.2.00.1101261008440.23080@router.home>
References: <20110125050255.13141.688.stgit@localhost6.localdomain6> <20110125050430.13141.21260.stgit@localhost6.localdomain6>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Reviewed-by: Christoph Lameter <cl@linux.com>

