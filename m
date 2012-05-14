Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365Ab2ENUMe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 16:12:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52980 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932285Ab2ENUMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 16:12:32 -0400
Date: Mon, 14 May 2012 13:12:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Please send a patch to set .gitignore to handle
 Documentation/misc-devices/mei/mei-amt-version
Message-ID: <20120514201228.GA21466@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm tired of seeing Documentation/misc-devices/mei/mei-amt-version show
up in 'git status' as an untracked file, care to please fix it up?

But really, shouldn't binary files like this to into tools/ instead of
Documentation?

thanks,

greg k-h
