Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab0EKLd4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 07:33:56 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:41272 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab0EKLdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 07:33:54 -0400
Date: Tue, 11 May 2010 13:33:47 +0200
From: Nils Radtke <lkml@Think-Future.de>
To: linux-kernel@vger.kernel.org
Subject: 2.6.34-rc7: keyboard CAPS on/off indifferent, always capital
Message-ID: <20100511113347.GD9838@localhost>
Reply-To: Nils Radtke <lkml@Think-Future.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://www.Think-Future.de
X-Editor: Vi it! http://www.vim.org
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  When resuming, the keys are capitalized but the CAPS LED is not lit. shift+key doesn't
  switch. Suspend-resume does temporarily fix it. As well as switching to console and back
  to X.

  Cheers,

  Nils

