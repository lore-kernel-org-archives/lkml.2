Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355Ab0JHNWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 09:22:43 -0400
Received: from exprod5og112.obsmtp.com ([64.18.0.24]:39524 "HELO
	exprod5og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753673Ab0JHNWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 09:22:42 -0400
Message-ID: <4CAF1AA1.1090801@panasas.com>
Date: Fri, 08 Oct 2010 09:20:33 -0400
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        open-osd <osd-dev@open-osd.org>, Benny Halevy <bhalevy@panasas.com>
Subject: [PATCH 0/2] exofs: Double page_unlock BUG in write_begin/write_end
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Oct 2010 13:20:31.0742 (UTC) FILETIME=[953E31E0:01CB66EB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Testing at Bakeathon, I got a page_unlock BUG_ON triggered.
I've found a very old bug, back from the days of the empire.
It is time related and it only triggers since couple of
rc-releases.

The first patch is the bug fix and I'd want to push it to Linus
for this version. If it's already to late I'll get it to the
merge window with a CC for stable.

The second patch is a cleanup that opened up do to the new
variable introduced in the bugfix above. Which I'll push for
the next release.

[PATCH 1/2] exofs: Fix double page_unlock BUG in write_begin/end
[PATCH 2/2] exofs: Cleaup read path in regard with read_for_write

Thanks
Boaz

