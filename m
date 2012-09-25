Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab2IYKMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 06:12:23 -0400
Received: from twin.jikos.cz ([89.185.236.188]:50515 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644Ab2IYKMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 06:12:19 -0400
Date: Tue, 25 Sep 2012 12:12:03 +0200
From: David Sterba <dave@jikos.cz>
To: zwu.kernel@gmail.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        jbacik@fusionio.com, dave@jikos.cz, linuxram@linux.vnet.ibm.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 1/2] btrfs-progs: Close file descriptor on exit
Message-ID: <20120925101203.GQ14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mail-Followup-To: zwu.kernel@gmail.com, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, jbacik@fusionio.com, dave@jikos.cz,
	linuxram@linux.vnet.ibm.com, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
References: <1348538536-29838-1-git-send-email-zwu.kernel@gmail.com>
 <1348538536-29838-2-git-send-email-zwu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348538536-29838-2-git-send-email-zwu.kernel@gmail.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 10:02:15AM +0800, zwu.kernel@gmail.com wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
>   Need to close fd on exit.

Strictly you don't need to, kernel will do that at exit() time.

david
