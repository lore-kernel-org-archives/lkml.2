Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab1JUGTZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 02:19:25 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:49249 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab1JUGTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 02:19:23 -0400
Subject: lio-core git tree back on kernel.org
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, "J.H." <warthog9@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Oct 2011 23:19:21 -0700
Message-ID: <1319177961.9778.79.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Folks,

This is a friendly heads-up that the lio-core / upstream target git tree
is now back on the new kernel.org infrastructure:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/lio-core.git

and available via gitweb here:

  http://git.kernel.org/?p=linux/kernel/git/nab/lio-core.git;a=summary

Given the opportunity, I’ve gone ahead and dropped the legacy '2.6'
suffix from the name, and asked J.H to symlink the new tree back to the
old location so current users won't notice the change..  This symlink
back to lio-core-2.6.git will be in place very soon..

A big thank you to J.H and the rest of the team for the continued hard
work involved in the getting the new K.O infrastructure in place.

Thank you,

--nab

