Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105Ab0GUNwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 09:52:36 -0400
Received: from peer.zerties.org ([188.40.33.175]:41135 "EHLO peer.zerties.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670Ab0GUNwe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 09:52:34 -0400
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Russell King <linux@arm.linux.org.uk>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: drivers/scsi/arm/acornsci.c -- Dead CONFIG_* options
Date: Wed, 21 Jul 2010 15:52:29 +0200
Message-ID: <86d3uhhrhe.fsf@peer.zerties.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!
       
        As part of the VAMOS[0] research project at the University of
Erlangen we are looking at multiple integrity errors in linux'
configuration system.

I also encountered some reference problems in
drivers/scsi/arm/acornscsi.c. But they seem to be intentionally, in
order to make integration into the linux kernel working. But the last
changelog entry is from 1998. So perhaps some of this ifdefs can be
removed. If this should be done i can make up a patch and send it.

[0] http://vamos1.informatik.uni-erlangen.de
-- 
(λ x . x x) (λ x . x x) -- See how beatiful the lambda is
No documentation is better than bad documentation
-- Das Ausdrucken dieser Mail wird urheberrechtlich verfolgt.
