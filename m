Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390Ab0EYJkT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 05:40:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60955 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726Ab0EYJkR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 05:40:17 -0400
Subject: Re: [PATCH V3] Split executable and non-executable mmap tracking
From: Peter Zijlstra <peterz@infradead.org>
To: Eric B Munson <ebmunson@us.ibm.com>
Cc: mingo@elte.hu, acme@redhat.com, arjan@linux.intel.com, anton@samba.org,
       riel@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <1274193049-25997-1-git-send-email-ebmunson@us.ibm.com>
References: <1274193049-25997-1-git-send-email-ebmunson@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 25 May 2010 11:39:55 +0200
Message-ID: <1274780395.5882.710.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-18 at 15:30 +0100, Eric B Munson wrote:

> +				mmap_data      :  1. /* non-exec mmap data    */

Things compile better if you use a ',' there :-)

anyway, fixed it up and will continue the compile..
