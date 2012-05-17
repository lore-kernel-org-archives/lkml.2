Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144Ab2EQQIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 12:08:36 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:35258 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754136Ab2EQQIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 12:08:35 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: jTpH7JoVM1m1EQLGxZSmosKvpQbJBqgv9pdD3VCkfzwPnXK
 eAR__dmd5AKg98wgaS8jwRAt2WJ4knf51wWHZSnlVPb_GPD9QgAZPgtaXwRF
 cKqeN7KBnzGZAJ.0XhyrBxmTND7y2v62oSp5gMYaHksANrAij59KB7xcIK3s
 obykisw5mcNISuD95AzMgWwqSEpsLxetkQ10FlIMTB_qSj6iKEZ4GTuGgIwL
 aB4k7yc6eFRnWr_7ZFEzVkY4yax1oLITde3s6.1MVkSmM64tftqoZr6iVFrK
 dDOmXJkBlU0vXR7pPEvSvx1geCMYJPHMyT2yoItIWAsbVTWWtHGXQTnvS8el
 2_AG5PGjpkvt3L8jBsqCcPQJz.nF3KtQSjhDitCGhB9Z8Ylz34_nU27WCvg4
 VO16dRH9ujlNlmVaDnSOXV7R_Ch8M.M2Rssun
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 17 May 2012 11:08:32 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Joonsoo Kim <js1304@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 0/4] slub: refactoring some code in slub
In-Reply-To: <1337269668-4619-1-git-send-email-js1304@gmail.com>
Message-ID: <alpine.DEB.2.00.1205171108000.5144@router.home>
References: <1337269668-4619-1-git-send-email-js1304@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2012, Joonsoo Kim wrote:

> Two patches were submitted 1 weeks ago, but doesn't receive ack or nack
> from MAINTAINER for slub. So I re-send these.

Could you combine the first two patches into one? They do the same thing.

