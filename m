Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab1CQPCp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 11:02:45 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:25091 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752880Ab1CQPCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 11:02:42 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: ZzA7vA8VM1lYm4YkG7iRVvwy44oacOkpKhGTjOsrZRmEZUw
 MFPBkM2aYVzkZsBryF9GV7ZWjSCSOjH1Yc7Iuocxcul.mHb7dsRD952sLfsz
 5dvRq5fjf4Po8FqjvL0qLXzcvq2s5qS0JOQhPQC.3Rzdr3a2OoqCVAXp2_mS
 fi_7gbZqnLDIEW1cQ7w7Gufx0wyI9TrmHV_JWEFFT0o6TivqV_wHukm0VDDz
 LLjAEwH2_vp1yJGuBhpE2ZRa9GAsJauzLM0Xkw4zNBWzO83vdf225GdjcMMH
 s.S88Gxc51qzFcqMCQx_eA40fZ_MMCvZawaroETpysmckgiNe8yH4
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 17 Mar 2011 08:54:00 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "Kirill A. Shutemov" <kirill@shutemov.name>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [PATCH 11/13] mm: use list_move() instead of list_del()/list_add()
 combination
In-Reply-To: <1300229605-14499-11-git-send-email-kirill@shutemov.name>
Message-ID: <alpine.DEB.2.00.1103170853370.12008@router.home>
References: <1300229605-14499-1-git-send-email-kirill@shutemov.name> <1300229605-14499-11-git-send-email-kirill@shutemov.name>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Reviewed-by: Christoph Lameter <cl@linux.com>

