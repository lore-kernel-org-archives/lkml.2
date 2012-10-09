Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab2JII3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 04:29:39 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:34658 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab2JII3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 04:29:37 -0400
Date: Tue, 9 Oct 2012 11:29:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Anmol Sarma <unmole.in@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org, arve@android.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: android: binder: Fixed multi-line strings
Message-ID: <20121009082918.GZ4587@mwanda>
References: <n>
 <1349722863-18835-1-git-send-email-unmole.in@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349722863-18835-1-git-send-email-unmole.in@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 12:31:03AM +0530, Anmol Sarma wrote:
> Changed all user visible multi-line stings to single line.
> 
> Signed-off-by: Anmol Sarma <unmole.in@gmail.com>

These sorts of things are really a judgement call.  checkpatch.pl is
being bossier than it should be.  I would ignore keep the
maintaier's original code.

regards,
dan carpenter

