Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab0JDJd7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 05:33:59 -0400
Received: from mx5.sophos.com ([213.31.172.35]:37242 "EHLO mx5.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061Ab0JDJd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 05:33:57 -0400
X-Greylist: delayed 419 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Oct 2010 05:33:57 EDT
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Fwd: Re: [BUG][PATCH][2.6.36-rc3] fanotify: Do not ignore result of permission decisions
Date: Mon, 4 Oct 2010 10:26:54 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-0.3-desktop; KDE/4.4.4; x86_64; ; )
MIME-Version: 1.0
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>
Message-ID: <201010041026.55057.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 04/10/2010 10:26:55,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 04/10/2010 10:26:56,
	Serialize complete at 04/10/2010 10:26:56
X-TNEFEvaluated: 1
Content-Type: multipart/mixed; boundary="Boundary-00=_f3ZqM6h74C6LrF/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_f3ZqM6h74C6LrF/
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"


Hi,

I am resending this since I worry 2.6.36 is released without this critical
fix.

Tvrtko

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United=
 Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.

--Boundary-00=_f3ZqM6h74C6LrF/
Content-Transfer-Encoding: 7bit
Content-Type: message/rfc822; name="forwarded message"
Content-Disposition: inline
Content-Description: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>: Re: [BUG][PATCH][2.6.36-rc3] fanotify: Do not ignore result of permission decisions

Content-Transfer-Encoding: quoted-printable
Received: from mx3.sophos.com (10.50.1.40) by uk-exch2.green.sophos
 (10.100.199.10) with Microsoft SMTP Server id 8.1.340.0; Wed, 8 Sep 2010
 09:24:56 +0100
Received: from mx3.sophos.com (localhost.localdomain [127.0.0.1])	by localhost
 (Postfix) with SMTP id E6A77FA0050;	Wed,  8 Sep 2010 09:24:55 +0100 (BST)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])	by
 mx3.sophos.com (Postfix) with ESMTP id 4B476FA000E;	Wed,  8 Sep 2010 09:24:55
 +0100 (BST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand	id
 S1758488Ab0IHIYP (ORCPT <rfc822;douglas.leeder@sophos.com>	+ 1 other); Wed, 8
 Sep 2010 04:24:15 -0400
Received: from mx4.sophos.com ([74.202.89.161]:37846 "EHLO mx4.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP	id S1758458Ab0IHIYM
 convert rfc822-to-8bit (ORCPT	<rfc822;linux-kernel@vger.kernel.org>);	Wed, 8
 Sep 2010 04:24:12 -0400
Received: from mx4.sophos.com (localhost.localdomain [127.0.0.1])	by localhost
 (Postfix) with SMTP id 2F7D97012F;	Wed,  8 Sep 2010 09:24:11 +0100 (BST)
Received: from uk-exch2.green.sophos (uk-exch2.green.sophos [10.100.199.17])
	by mx4.sophos.com (Postfix) with ESMTP id C4680700DA;	Wed,  8 Sep 2010
 09:24:10 +0100 (BST)
Received: from mercury.green.sophos (10.1.200.13) by uk-exch2.green.sophos
 (10.100.199.10) with Microsoft SMTP Server id 8.1.340.0; Wed, 8 Sep 2010
 09:24:10 +0100
Received: from deuteros.localnet ([10.101.101.208])          by
 mercury.green.sophos (Lotus Domino Release 7.0.3)          with ESMTP id
 2010090809240615-72352 ;          Wed, 8 Sep 2010 09:24:06 +0100 
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
To: Eric Paris <eparis@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Sender: "linux-kernel-owner@vger.kernel.org"
	<linux-kernel-owner@vger.kernel.org>
Date: Wed, 8 Sep 2010 09:24:04 +0100
Subject: Re: [BUG][PATCH][2.6.36-rc3] fanotify: Do not ignore result of
 permission decisions
Thread-Topic: [BUG][PATCH][2.6.36-rc3] fanotify: Do not ignore result of
 permission decisions
Thread-Index: ActPL1Ie8fAPdgdfSdCm31W+fVOnkA==
Message-ID: <201009080924.04841.tvrtko.ursulin@sophos.com>
References: <201009071608.02290.tvrtko.ursulin@sophos.com>
In-Reply-To: <201009071608.02290.tvrtko.ursulin@sophos.com>
Accept-Language: en-GB, en-US
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-AuthSource: uk-exch2.green.sophos
X-MS-Has-Attach: 
X-Auto-Response-Suppress: All
X-MS-TNEF-Correlator: 
x-mimetrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release
 7.0.3|September 26, 2007) at 08/09/2010 09:24:06,	Serialize by Router on
 Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at 08/09/2010
 09:24:10,	Serialize complete at 08/09/2010 09:24:10
x-tnefevaluated: 1
x-pmx-version: 5.6.0.2009776, Antispam-Engine: 2.7.2.376379, Antispam-Data:
 2010.9.8.81515
x-pmx-queueid: us-col-mx1.brown.sophos:4C874857_20722_2853_1
x-spam-report: The following antispam rules were triggered by this message:
	Rule                 Score Description	BODY_SIZE_4000_4999  0.000 Message
 body size is 4000 to 4999 bytes	BODY_SIZE_5000_LESS  0.000 Message body size
 is less than 5000 bytes.	BODY_SIZE_7000_LESS  0.000 Message body size is
 less than 5000 bytes.
dkim-signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sophos.com;
 h=from:to:subject:date:cc:references:in-reply-to:mime-version:message-id:content-transfer-encoding:content-type;
 s=global; bh=ZwpBwI3is9V0fhYBdKifsGfQf//Sij6vaEN9jtjSBqc=;
 b=EaB1uZHSROUzB1MBi6Omgh0T1EnKbGM21FVSEC+b+NjnRyd0GnowsAYaOa8BXcex/3y0XP2f9X6mGxiQQYs5uReqUo0Rop7sLfn92B7e5KEy9HBRTi+86Z47KKU8V2NdZqBaWHC1yj2ySDJ0xPMjKKRU7OBXptD88Z/AtfEkDRw=
list-id: <linux-kernel.vger.kernel.org>
x-perlmx-spam: Gauge=IIIIIIII. Probability=8%, Report=' BODY_SIZE_4000_4999
 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __BOUNCE_CHALLENGE_SUBJ 0,
 __BOUNCE_NDR_SUBJ_EXEMPT 0, __CP_NAME_BODY 0, __CP_URI_IN_BODY 0, __CT 0,
 __CTE 0, __CT_TEXT_PLAIN 0, __FRAUD_REFNUM 0, __HAS_MSGID 0,
 __HAS_X_MAILING_LIST 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID
 0, __TO_MALFORMED_2 0, __URI_NS , __USER_AGENT 0'
user-agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
x-mailing-list: linux-kernel@vger.kernel.org
MIME-Version: 1.0
X-Length: 13914
X-UID: 1322
Content-Type: text/plain;
  charset="us-ascii"
Content-Language: en-US


Improved version of the fix which does not include the check
when permission events are not enabled in configuration and
stops processing if no interesting events remain.

Current code ignores access replies to permission decisions so
fix it in a way which will allow all listeners to still receive
non permission events.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
---
 fs/notify/fsnotify.c             |   32 ++++++++++++++++++++++++--------
 include/linux/fsnotify_backend.h |    4 ++++
 2 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 3680242..2350a53 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -224,7 +224,7 @@ int fsnotify(struct inode *to_tell, __u32 mask, void *d=
ata, int data_is,
        struct fsnotify_group *inode_group, *vfsmount_group;
        struct fsnotify_event *event =3D NULL;
        struct vfsmount *mnt;
-       int idx, ret =3D 0;
+       int idx, ret =3D 0, res;
        /* global tests shouldn't care about events on child only the speci=
fic event */
        __u32 test_mask =3D (mask & ~FS_EVENT_ON_CHILD);

@@ -275,20 +275,36 @@ int fsnotify(struct inode *to_tell, __u32 mask, void =
*data, int data_is,

                if (inode_group > vfsmount_group) {
                        /* handle inode */
-                       send_to_group(to_tell, NULL, inode_mark, NULL, mask=
, data,
-                                     data_is, cookie, file_name, &event);
+                       res =3D send_to_group(to_tell, NULL, inode_mark, NU=
LL, mask, data,
+                                           data_is, cookie, file_name, &ev=
ent);
                        /* we didn't use the vfsmount_mark */
                        vfsmount_group =3D NULL;
                } else if (vfsmount_group > inode_group) {
-                       send_to_group(to_tell, mnt, NULL, vfsmount_mark, ma=
sk, data,
-                                     data_is, cookie, file_name, &event);
+                       res =3D send_to_group(to_tell, mnt, NULL, vfsmount_=
mark, mask, data,
+                                           data_is, cookie, file_name, &ev=
ent);
                        inode_group =3D NULL;
                } else {
-                       send_to_group(to_tell, mnt, inode_mark, vfsmount_ma=
rk,
-                                     mask, data, data_is, cookie, file_nam=
e,
-                                     &event);
+                       res =3D send_to_group(to_tell, mnt, inode_mark, vfs=
mount_mark,
+                                           mask, data, data_is, cookie, fi=
le_name,
+                                           &event);
                }

+#ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
+               /* If a listener denied on a permission event we will remem=
ber the reason
+                  and run the rest with a non-permission mask only. This a=
llows other
+                  listeners to receive non-permission notifications but we=
 do not care
+                  about further permission checks and want to deny this ev=
ent. */
+               if (unlikely((res =3D=3D -EPERM) && (mask & FS_ALL_PERM_EVE=
NTS))) {
+                       mask &=3D ~FS_ALL_PERM_EVENTS;
+                       ret =3D res;
+                       /* Stop processing if no interesting events remains=
. */
+                       if (!(mask & (ALL_FSNOTIFY_EVENTS & ~FS_EVENT_ON_CH=
ILD)))
+                               break;
+               }
+#else
+               (void)res;
+#endif
+
                if (inode_group)
                        inode_node =3D srcu_dereference(inode_node->next,
                                                      &fsnotify_mark_srcu);
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_back=
end.h
index e40190d..c8aea03 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -64,6 +64,10 @@

 #define FS_MOVE                        (FS_MOVED_FROM | FS_MOVED_TO)

+/* All events which require a permission response from userspace */
+#define FS_ALL_PERM_EVENTS (FS_OPEN_PERM |\
+                           FS_ACCESS_PERM)
+
 #define ALL_FSNOTIFY_EVENTS (FS_ACCESS | FS_MODIFY | FS_ATTRIB | \
                             FS_CLOSE_WRITE | FS_CLOSE_NOWRITE | FS_OPEN | =
\
                             FS_MOVED_FROM | FS_MOVED_TO | FS_CREATE | \

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United=
 Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

--Boundary-00=_f3ZqM6h74C6LrF/--
