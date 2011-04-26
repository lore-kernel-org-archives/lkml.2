Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758963Ab1DZWpT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 18:45:19 -0400
Received: from nd215.dnsexit.com ([64.182.102.215]:58419 "EHLO
	box7.911domain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758509Ab1DZWpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 18:45:17 -0400
X-Complaints-To: abuse@dnsExit.com
X-SPAM: Please report Spam to abuse@dnsExit.com
        By service at http://www.dnsExit.com/Direct.sv?cmd=mailRelay
        Accounts will be suspended immediately if convicted Spam
Message-ID: <4DB74AD2.9070302@verizon.net>
Date: Tue, 26 Apr 2011 18:44:34 -0400
From: Peter Foley <pefoley2@verizon.net>
Reply-To: <pefoley2@verizon.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <linux-kbuild@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH V2 0/7] kbuild: scripts/kconfig/Makefile cleanup and fixes
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set:
Changes the update-po-config target to work when make is run from KBUILD_OUTDIR.
Changes the update-po-config target to reflectg the new layout of arch/um.
Adds a check to only build kxgettext when needed.
Changes the qconf and gconf targets to change hostprogs-y when they are being built like nconf and mconf instead of defining *-objs.
Cleans up the clean-files definitions.
Silences comands unless V=1


Please discard my previous patch: "kbuild: scripts/kconfig/Makefile cleanup and fixes"

Thanks,

Peter
