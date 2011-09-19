Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab1ISRwM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 13:52:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46380 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320Ab1ISRwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 13:52:07 -0400
Date: Mon, 19 Sep 2011 19:52:03 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: Jeff liu <jeff.liu@oracle.com>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Andi Kleen <ak@linux.intel.com>, Andreas Dilger <adilger@dilger.ca>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/7] BTRFS: Fix lseek return value for error
Message-ID: <20110919175203.GK7761@one.firstfloor.org>
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org> <1316128013-21980-2-git-send-email-andi@firstfloor.org> <20110916154815.GA27150@infradead.org> <4E7439EB.7080100@oracle.com> <41C7FF67-8658-4E7F-BB50-E9AAEA1F755C@dilger.ca> <20110918014608.GA16198@alboin.amr.corp.intel.com> <4E759DE5.3020907@oracle.com> <4E75AEFD.105@gmail.com> <8444301C-856F-44FA-94A3-D3583DFA0FFB@oracle.com> <1316357705-sup-2667@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316357705-sup-2667@shiny>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Thanks everyone, I've put Jeff's last version of this in my queue.

Can you post the version you merged? The previous ones all had issues.

-Andi
