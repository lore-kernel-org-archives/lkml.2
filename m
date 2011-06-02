Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647Ab1FBTLH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 15:11:07 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:53801 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752361Ab1FBTLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 15:11:05 -0400
X-Sasl-enc: 0uXG7QaSjIrpMZqeCGhT/hKsIndy5ESKPsgJcwdjyH7q 1307041864
Date: Thu, 2 Jun 2011 16:11:01 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Preparation for Linux 3.0
Message-ID: <20110602191101.GC31586@khazad-dum.debian.net>
References: <201106020350.p523o95o094928@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106020350.p523o95o094928@www262.sakura.ne.jp>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Jun 2011, Tetsuo Handa wrote:
> We need to widely announce that userland applications using branches based on
> /proc/sys/kernel/osrelease need to be fixed.

A debug patch to disclose any userspace application that touches that file
would be of some help, I suppose?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
