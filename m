Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593Ab2FTXlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 19:41:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58824 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758416Ab2FTXlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 19:41:06 -0400
Date: Wed, 20 Jun 2012 16:41:01 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 2/4] mei: make mei_write_message more readable
Message-ID: <20120620234101.GA23638@kroah.com>
References: <1340086417-23090-1-git-send-email-tomas.winkler@intel.com>
 <1340086417-23090-2-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340086417-23090-2-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 09:13:35AM +0300, Tomas Winkler wrote:
> 1. reduce hairy casting
> 2. replace open code with mei_count_empty_write_slots
> 4. include header size in check for overflow
> 3. use concise for loop instead of a while loop
> 
> Change-Id: Idb7423bd7bc570a46437568908a0e8f6d7225555

What is that nonsense?

Ick.

I'll delete it this time, but please, never again...
