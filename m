Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab0DOOsH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 10:48:07 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:36834 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab0DOOsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 10:48:05 -0400
Date: Thu, 15 Apr 2010 16:48:00 +0200
From: Daniel Mack <daniel@caiaq.de>
To: roywoco <roy.chan@travelex.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Repeat a command in background
Message-ID: <20100415144800.GW30801@buzzloop.caiaq.de>
References: <28255878.post@talk.nabble.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28255878.post@talk.nabble.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 07:16:03AM -0700, roywoco wrote:
> I would like to capture the output of vmstat every 10 min into a file. Can
> anyone know how I can do it?

Very wrong list for such questions, dude. Nevermind ...

#!/bin/sh

file=/tmp/file
while [ true ]; do
	cat /proc/vmstat >> $file
	sleep 600
done

