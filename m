Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab1K2TR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 14:17:29 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37775 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280Ab1K2TR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 14:17:28 -0500
Message-Id: <20111129191252.769160532@openvz.org>
User-Agent: quilt/0.48-1
Date: Tue, 29 Nov 2011 23:12:52 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: [rfc 0/3] A small bundle in a sake of checkpoint/restore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this series introduce a few changes we need for checkpoint,
restore procedures. Mostly harmless I think, but complains
and comments are really appreciated. My main concern is
new prctl codes.

Thanks,
 Cyrill
