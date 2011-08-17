Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab1HQN5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 09:57:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46785 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab1HQN5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 09:57:22 -0400
Date: Wed, 17 Aug 2011 15:57:19 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: "Theodore Ts'o" <tytso@MIT.EDU>, Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Sunil Mushran <sunil.mushran@oracle.com>,
        Joel Becker <jlbec@evilplan.org>, Mingming Cao <cmm@us.ibm.com>,
        Amir Goldstein <amir73il@gmail.com>, Coly Li <colyli@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] ext4 metadata checksumming design
Message-ID: <20110817135719.GA25996@one.firstfloor.org>
References: <20110817032519.GN20655@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110817032519.GN20655@tux1.beaverton.ibm.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 08:25:19PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> I've created a page on the ext4 wiki outlining the patchset that I'm working on
> to add metadata checksumming to ext4.  The page can be found at this address:
> https://ext4.wiki.kernel.org/index.php/Ext4_Metadata_Checksums

Can you summarize the differences to my earlier patchkit?

-Andi
