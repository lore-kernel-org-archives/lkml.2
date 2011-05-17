Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496Ab1EQWmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 18:42:38 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53424 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932399Ab1EQWmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 18:42:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=hgVSwXGbpJRiqJ88X9ti5AvZZqkNrn69AelZpOFG8yZtwrWLsLkiRyDLufdGuMHttx
         aiUdDLiwnfN+zCKZvHuCyTSbTxniCfLswk52SDQcVM2OpCVELiooo9sjK2M8PmNZwcaw
         HO3KTCGY2WLTJHpPVLQZ+9gj2pztwFBieTlNA=
MIME-Version: 1.0
Date: Tue, 17 May 2011 17:42:35 -0500
Message-ID: <BANLkTinfk5XQ5a2fhRjOao9-ziOry97N6A@mail.gmail.com>
Subject: Two cifs fixes
From: Steve French <smfrench@gmail.com>
To: linux-cifs@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Have queued up two recently found cifs fixes in the cifs git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git master

Jeff Layton (2):
      cifs: add fallback in is_path_accessible for old servers
      cifs: fix cifsConvertToUCS() for the mapchars case

 fs/cifs/cifs_unicode.c |   14 ++++++--------
 fs/cifs/connect.c      |    5 +++++
 2 files changed, 11 insertions(+), 8 deletions(-)

Given how late (rc7) any additional testing appreciated (Jeff and
Shirish and I have tested these).
-- 
Thanks,

Steve
