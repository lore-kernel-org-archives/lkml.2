Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab1ATQrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 11:47:36 -0500
Received: from kroah.org ([198.145.64.141]:42061 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227Ab1ATQrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 11:47:35 -0500
Date: Thu, 20 Jan 2011 08:45:55 -0800
From: Greg KH <greg@kroah.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Robin Holt <holt@sgi.com>
Subject: Re: [PATCH 0/4] De-couple sysfs memory directories from memory
 sections
Message-ID: <20110120164555.GA30922@kroah.com>
References: <4D386498.9080201@austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D386498.9080201@austin.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 10:36:40AM -0600, Nathan Fontenot wrote:
> The root of this issue is in sysfs directory creation. Every time
> a directory is created a string compare is done against sibling
> directories ( see sysfs_find_dirent() ) to ensure we do not create 
> duplicates.  The list of directory nodes in sysfs is kept as an
> unsorted list which results in this being an exponentially longer
> operation as the number of directories are created.

Again, are you sure about this?  I thought we resolved this issue in the
past, but you were going to check it.  Did you?

thanks,

greg k-h
