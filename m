Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab0JKMzj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 08:55:39 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:31311 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754131Ab0JKMzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 08:55:38 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: YCQk4z0VM1mgrR_14H8cPZVOgHiJn4qjzNwPfqaKzS6oamy
 hK.aATuK9OPvS6UG1nzTDAVvgbwLmwe0tZY_dfT_RUJ9XnB2WSGN9p0sOMB5
 .xJFFgpLsApkeLQfs2WUvqvpJUlJj_v.fvbqNXF_oLLXns5X0h35l7GCK2ij
 S1MoaHX5Sm23LxlGb_7IS9Zdaplpgnw.xGfe3Qwe5Ws8_N4mWCduVRlZy7nc
 Cq_t2j07qO82QWuGByXp9IYp_9iTjwIOoJe6yYIEqZrI-
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 11 Oct 2010 07:55:35 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Prasad Joshi <prasadjoshi124@gmail.com>
cc: linux-fsdevel@vger.kernel.org, Joern <joern@logfs.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>,
        logfs@logfs.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [LogFS][2.6.36.rc7+] Kernel BUG at readwrite.c:1193
In-Reply-To: <AANLkTi=JkcuWBPo+X-i+9o-BJFVqjea1J3e=Mr=HvAWF@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1010110754290.6638@router.home>
References: <AANLkTi=JkcuWBPo+X-i+9o-BJFVqjea1J3e=Mr=HvAWF@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Oct 2010, Prasad Joshi wrote:

> <2>[ 4452.144286] kernel BUG at /home/prasad/logfs_code/readwrite.c:1193!

Looks like an invalid ta->state was passed to logfs_handle_transaction()?

