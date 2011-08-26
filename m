Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab1HZQdy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 12:33:54 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:38017 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754804Ab1HZQdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 12:33:53 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: cPMInggVM1n8788cRirMKTJMydSmi6YGqSVePYozKy8ZHfh
 j8uuUu6068.CKGl4hGkkfk.578W0NTMMarUb1Hd5maYPLgZT_oHl6mgm1UXD
 Ms3wefn6eBOmXNo3rxFJUW5hqhxbP0r23h_iATiEmSxkssjFjD1MWYGBYzy4
 nSMdFhFH3MCn2I6HWGnBUyq7uQK_20VfLf5QvkMPpM4LTGMufNbXSfvQNiLg
 .Xqe9gbYX8O_5SWwiqtbv8hnobvPKBQn6pVtlqTdWYr5lKlu1Bk3hVM21dC7
 QlaGBUKRFae5lVfVkjS3CfgP.UM8yJihB93gUu0cvlz5ePd2zf0Wr4qpuIF6
 hoLlWelF0IRqTh2.EKUigy3pmRBRMg8hNs0YZjWozTPdY
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 26 Aug 2011 11:33:49 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Zhao Jin <cronozhj@gmail.com>
cc: penberg@kernel.org, mpm@selenic.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2][RESEND] slab, cleanup: remove unneeded return
In-Reply-To: <1314375977-14927-1-git-send-email-cronozhj@gmail.com>
Message-ID: <alpine.DEB.2.00.1108261133290.8296@router.home>
References: <1314375977-14927-1-git-send-email-cronozhj@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Aug 2011, Zhao Jin wrote:

> The procedure ends right after the if-statement, so remove ``return''.
> Also move the last common statement outside.

Acked-by: Christoph Lameter <cl@linux.com>

