Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab1GFSE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 14:04:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754864Ab1GFSEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 14:04:25 -0400
Date: Wed, 6 Jul 2011 15:03:58 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH RFCv3 12/17] [media] DocBook/demux.xml: Remove generic
 errors
Message-ID: <20110706150358.2d6a902b@pedra>
In-Reply-To: <cover.1309974026.git.mchehab@redhat.com>
References: <cover.1309974026.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove generic errors from ioctl() descriptions. For other ioctl's,
there's no generic section. So, just keep whatever is there.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media/dvb/demux.xml b/Documentation/DocBook/media/dvb/demux.xml
index e5058d7..37c1790 100644
--- a/Documentation/DocBook/media/dvb/demux.xml
+++ b/Documentation/DocBook/media/dvb/demux.xml
@@ -552,13 +552,6 @@ typedef enum {
 &return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
-<para>EBADF</para>
-</entry><entry
- align="char">
-<para>fd is not a valid file descriptor.</para>
-</entry>
- </row><row><entry
- align="char">
 <para>EINVAL</para>
 </entry><entry
  align="char">
@@ -615,14 +608,6 @@ typedef enum {
 </entry>
  </row></tbody></tgroup></informaltable>
 &return-value-dvb;
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>EBADF</para>
-</entry><entry
- align="char">
-<para>fd is not a valid file descriptor.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
 </section>
 
 <section id="DMX_SET_FILTER">
@@ -677,21 +662,6 @@ typedef enum {
 </entry>
  </row></tbody></tgroup></informaltable>
 &return-value-dvb;
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>EBADF</para>
-</entry><entry
- align="char">
-<para>fd is not a valid file descriptor.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EINVAL</para>
-</entry><entry
- align="char">
-<para>Invalid argument.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
 </section>
 
 <section id="DMX_SET_PES_FILTER">
@@ -751,20 +721,6 @@ typedef enum {
 &return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
-<para>EBADF</para>
-</entry><entry
- align="char">
-<para>fd is not a valid file descriptor.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EINVAL</para>
-</entry><entry
- align="char">
-<para>Invalid argument.</para>
-</entry>
- </row><row><entry
- align="char">
 <para>EBUSY</para>
 </entry><entry
  align="char">
@@ -820,22 +776,6 @@ typedef enum {
 </entry>
  </row></tbody></tgroup></informaltable>
 &return-value-dvb;
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>EBADF</para>
-</entry><entry
- align="char">
-<para>fd is not a valid file descriptor.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>ENOMEM</para>
-</entry><entry
- align="char">
-<para>The driver was not able to allocate a buffer of the
- requested size.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
 </section>
 
 <section id="DMX_GET_EVENT">
@@ -894,20 +834,6 @@ typedef enum {
 &return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
-<para>EBADF</para>
-</entry><entry
- align="char">
-<para>fd is not a valid file descriptor.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EFAULT</para>
-</entry><entry
- align="char">
-<para>ev points to an invalid address.</para>
-</entry>
- </row><row><entry
- align="char">
 <para>EWOULDBLOCK</para>
 </entry><entry
  align="char">
@@ -967,20 +893,6 @@ typedef enum {
 &return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
-<para>EBADF</para>
-</entry><entry
- align="char">
-<para>fd is not a valid file descriptor.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EFAULT</para>
-</entry><entry
- align="char">
-<para>stc points to an invalid address.</para>
-</entry>
- </row><row><entry
- align="char">
 <para>EINVAL</para>
 </entry><entry
  align="char">
diff --git a/Documentation/DocBook/media/v4l/gen-errors.xml b/Documentation/DocBook/media/v4l/gen-errors.xml
index 9a9575f..3e6ddd9 100644
--- a/Documentation/DocBook/media/v4l/gen-errors.xml
+++ b/Documentation/DocBook/media/v4l/gen-errors.xml
@@ -48,6 +48,11 @@
 	       that this request would overcommit the usb bandwidth reserved
 	       for periodic transfers (up to 80% of the USB bandwidth).</entry>
       </row>
+      <row>
+	<entry>EWOULDBLOCK</entry>
+	<entry>Operation would block. Used when the ioctl would need to wait
+	       for an event, but the device was opened in non-blocking mode.</entry>
+      </row>
     </tbody>
   </tgroup>
 </table>
-- 
1.7.1


