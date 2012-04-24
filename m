Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab2DXSRy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 14:17:54 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:28859 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755725Ab2DXSRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 14:17:53 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: QXEjxP8VM1nD1rppMmY9snJvF4y10QFDFdD60Usqig.vLUE
 yKhxJqXiS31spPhEiAqmbNOZINKm0E6mzvGkLLrsauyh3TK6bVNMel2EC_EZ
 ZMQ_rGLDYxFzXeX8XTaC5blGjZvrFPYwNW0BLRDj8t15bVa6CAxO3W1d1TP6
 emPnbx7ccDAy8sdp9utZ81AJ5SrLMthfO5FpxovtvlgWDbz6rzF5Kkpo4WbQ
 HMCQiefnfxw831H56bfoJCYbgODqzI2twx_tktFmA2K6AQm328OYYbdVt1dg
 O2fH1nNvq3ITIl52D7JKhcNbeoc0Om6nFqk4FTR32BY0B7i67D0DBd7HMgps
 RzK_lt6m1X3KTa18jg50AMbLOjlOoMlr9.i2O_3kzRMpG5hep5FFhWFf1ULV
 gvGf3DOjRnE6VBBluiSU7qrVXzZT9zTCARTfweMSJ
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 24 Apr 2012 13:17:49 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Larry Woodman <lwoodman@redhat.com>
cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, linux-mm@kvack.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Motohiro Kosaki <mkosaki@redhat.com>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm V2] do_migrate_pages() calls migrate_to_node() even
 if task is already on a correct node
In-Reply-To: <4F96DFE0.6040306@redhat.com>
Message-ID: <alpine.DEB.2.00.1204241317170.26005@router.home>
References: <4F96CDE1.5000909@redhat.com> <4F96D27A.2050005@gmail.com> <4F96DFE0.6040306@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; FORMAT=flowed
Content-ID: <alpine.DEB.2.00.1204241317172.26005@router.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2012, Larry Woodman wrote:

> How does this look:

Could you please send the patches inline? Its difficult to quote the
attachment.

