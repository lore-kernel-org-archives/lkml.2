Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934250Ab2C3Lj0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 07:39:26 -0400
Received: from server.atrad.com.au ([150.101.241.2]:58672 "EHLO
	server.atrad.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933561Ab2C3LjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 07:39:21 -0400
Date: Fri, 30 Mar 2012 22:09:15 +1030
From: Jonathan Woithe <jwoithe@just42.net>
To: oakad@yahoo.com
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        jwoithe@just42.net
Subject: Possible issue with tifm_7xx1 and interrupt latency
Message-ID: <20120330113915.GE9075@marvin.atrad.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although somewhat circumstancial, during the debugging of a FFADO issue with
a user it seemed possible that the tifm_7xx1 module may have been switching
interrupts off for long periods of time.  For a full history of the problem
please refer to

  http://subversion.ffado.org/ticket/250

Unfortunately the original reporter no longer has access to the hardware
concerned and the report itself dates from 2 years ago (I kept forgetting
to report it).  However, it may be useful none-the-less.

Please CC me any replies.

Thanks
  jonathan
