Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751354Ab0KWCyq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 21:54:46 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47233 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab0KWCyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 21:54:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=q/3808M9YgGsisVoOLoVHQAx6i470naFCFjqaONp3ZwgO1Tx+QgPA3bspKwe9MqU5a
         NT628+mtzeCd3XfCVCPeHk6Kf/v9mLGdhsJQob7FDlfv+cEiRL3a/ABMvU6o+EUeooXU
         yNxRwRm3LJHMa/MJNQ29dscZLpBUG62+o1Tqc=
Subject: Re: [PATCH] scripts: Fix gfp-translate for recent changes to gfp.h
From: Namhyung Kim <namhyung@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101122120002.GB1890@csn.ul.ie>
References: <20101122120002.GB1890@csn.ul.ie>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Nov 2010 11:54:36 +0900
Message-ID: <1290480876.1857.2.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-11-22 (월), 12:00 +0000, Mel Gorman:
> The recent changes to gfp.h to satisfy sparse broke
> scripts/gfp-translate. This patch fixes it up to work with old and new
> versions of gfp.h .

Oh, I didn't even know the script exists. Sorry.

-- 
Regards,
Namhyung Kim


