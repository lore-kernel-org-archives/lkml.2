Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab1HXNzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 09:55:53 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:32403 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750767Ab1HXNzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 09:55:50 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 5kigoqIVM1mko3TN4NOhJAoBTAJuIOVS_QEJFMubPatiRMV
 D6g98awf0WtWyWtG6sK6CmxZ5C4z9WQt2KDag6oH5RQth6QX0rOVQfPtRQ7B
 9T4mnR3SX0PsMD_m_iSYHb2n7VDknyq9HqIsdXm6eachH_GMDUxQCMuH.LfY
 AIelXZUbz.RDfq7Pv3Ff_5i9I94kYJbOG6Fjol3qR9J66Efw5ivflFV1UVhA
 loSyDT2ZPOpcp.W7CVAXEh9xyMp4ueWBCYT0qsNyXFnAgJxuLDOzJGCcH6AH
 6E8TRnU1nOXJTN3m1EWkKC9zSnwsAWbfBqLHw3F8pt3dh0_UnkdUrh97hGEf
 X0gxoAIw0_PG4J9BwF39M3WW0eddhJ7f_bh7POsqvRBbGHNHL75MVGMGDeVP
 HeHzyS.EtsTXQrc3vm05z
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 24 Aug 2011 08:55:47 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Shaohua Li <shaohua.li@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "penberg@kernel.org" <penberg@kernel.org>,
        "Shi, Alex" <alex.shi@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [patch 2/2]slub: add a type for slab partial list position
In-Reply-To: <1314147472.29510.25.camel@sli10-conroe>
Message-ID: <alpine.DEB.2.00.1108240855290.24118@router.home>
References: <1314059823.29510.19.camel@sli10-conroe>  <alpine.DEB.2.00.1108231023470.21267@router.home> <1314147472.29510.25.camel@sli10-conroe>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Aug 2011, Shaohua Li wrote:

> Subject: slub: explicitly document position of inserting slab to partial list

Acked-by: Christoph Lameter <cl@linux.com>

