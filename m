Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab2AZPb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 10:31:26 -0500
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:48645 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752004Ab2AZPbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 10:31:25 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: KVRJ7ocVM1lA65D37RZYAgtdAFokZBJPuDv_MTKvJCV.mvr
 iuWqZ8UJKQsjSmZgNTAjOL6hxqwXk5_dKa32MS9ek1mbhRXM1fnIa7mGOnBJ
 4pKBMUQDr_87Z0FNIlZ5ds9GpGwK39u5vY5_6NCnq.2tNTCAGWtEJ6eq_t5x
 9lJrMaA_mz0ZS5TtnLEMrlQOFJ.sJk1bivZQTiQH5BJxX05RO6MsSbHjNYJ5
 QgUV.hUvUTAuqvd_MVIc8SASWCDU9AZQGt1Dr8vhpVk2RLJboDijuJdbKjLW
 tGNcdEdIiEejlco3TDSyY49Cyi7LoGrs.hGXv.VAOAbJWMMo9Z4S9tB3mItP
 jmQw7xotzU2aimHqDa.WF95nnKNXKbxXAqDTVXURI8EzP4boulS6D2_Foc9W
 TVETX
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 26 Jan 2012 09:09:47 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Gilad Ben-Yossef <gilad@benyossef.com>
cc: linux-kernel@vger.kernel.org, Chris Metcalf <cmetcalf@tilera.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Michal Nazarewicz <mina86@mina86.org>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>,
        Milton Miller <miltonm@bga.com>
Subject: Re: [v7 5/8] slub: only IPI CPUs that have per cpu obj to flush
In-Reply-To: <1327572121-13673-6-git-send-email-gilad@benyossef.com>
Message-ID: <alpine.DEB.2.00.1201260909190.23426@router.home>
References: <1327572121-13673-1-git-send-email-gilad@benyossef.com> <1327572121-13673-6-git-send-email-gilad@benyossef.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jan 2012, Gilad Ben-Yossef wrote:

> produces 166 IPIs on an cpuset isolated CPU. With it it produces none.

Acked-by: Christoph Lameter <cl@linux.com>

