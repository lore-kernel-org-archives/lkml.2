Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab1GFSIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 14:08:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754750Ab1GFSEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 14:04:22 -0400
Date: Wed, 6 Jul 2011 15:03:57 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH RFCv3 11/17] [media] DocBook/audio.xml: Remove generic
 errors
Message-ID: <20110706150357.454865d0@pedra>
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
Also remove the EINTERNAL error code, as no DVB driver returns
it, and this error code is not defined on POSIX or on Linux.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media/dvb/audio.xml b/Documentation/DocBook/media/dvb/audio.xml
index 90e9b7f..d643862 100644
--- a/Documentation/DocBook/media/dvb/audio.xml
+++ b/Documentation/DocBook/media/dvb/audio.xml
@@ -230,13 +230,6 @@ and right.
 </entry>
  </row><row><entry
  align="char">
-<para>EINTERNAL</para>
-</entry><entry
- align="char">
-<para>Internal error.</para>
-</entry>
- </row><row><entry
- align="char">
 <para>EBUSY</para>
 </entry><entry
  align="char">
@@ -392,21 +385,6 @@ role="subsection"><title>AUDIO_STOP</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 &return-value-dvb;
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>EBADF</para>
-</entry><entry
- align="char">
-<para>fd is not a valid open file descriptor</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EINTERNAL</para>
-</entry><entry
- align="char">
-<para>Internal error.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
 
 </section><section id="AUDIO_PLAY"
 role="subsection"><title>AUDIO_PLAY</title>
@@ -443,21 +421,6 @@ role="subsection"><title>AUDIO_PLAY</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 &return-value-dvb;
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>EBADF</para>
-</entry><entry
- align="char">
-<para>fd is not a valid open file descriptor</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EINTERNAL</para>
-</entry><entry
- align="char">
-<para>Internal error.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
 
 </section><section id="AUDIO_PAUSE"
 role="subsection"><title>AUDIO_PAUSE</title>
@@ -502,22 +465,6 @@ role="subsection"><title>AUDIO_PAUSE</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 &return-value-dvb;
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>EBADF</para>
-</entry><entry
- align="char">
-<para>fd is not a valid open file descriptor.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EINTERNAL</para>
-</entry><entry
- align="char">
-<para>Internal error.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-
 
 </section><section id="AUDIO_CONTINUE"
 role="subsection"><title>AUDIO_CONTINUE</title>
@@ -558,21 +505,6 @@ with AUDIO_PAUSE command.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
 &return-value-dvb;
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>EBADF</para>
-</entry><entry
- align="char">
-<para>fd is not a valid open file descriptor.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EINTERNAL</para>
-</entry><entry
- align="char">
-<para>Internal error.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
 
 </section><section id="AUDIO_SELECT_SOURCE"
 role="subsection"><title>AUDIO_SELECT_SOURCE</title>
@@ -621,28 +553,6 @@ role="subsection"><title>AUDIO_SELECT_SOURCE</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 &return-value-dvb;
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>EBADF</para>
-</entry><entry
- align="char">
-<para>fd is not a valid open file descriptor.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EINTERNAL</para>
-</entry><entry
- align="char">
-<para>Internal error.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EINVAL</para>
-</entry><entry
- align="char">
-<para>Illegal input parameter.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
 
 </section><section id="AUDIO_SET_MUTE"
 role="subsection"><title>AUDIO_SET_MUTE</title>
@@ -699,28 +609,6 @@ role="subsection"><title>AUDIO_SET_MUTE</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 &return-value-dvb;
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>EBADF</para>
-</entry><entry
- align="char">
-<para>fd is not a valid open file descriptor.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EINTERNAL</para>
-</entry><entry
- align="char">
-<para>Internal error.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EINVAL</para>
-</entry><entry
- align="char">
-<para>Illegal input parameter.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
 
 </section><section id="AUDIO_SET_AV_SYNC"
 role="subsection"><title>AUDIO_SET_AV_SYNC</title>
@@ -777,28 +665,6 @@ role="subsection"><title>AUDIO_SET_AV_SYNC</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 &return-value-dvb;
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>EBADF</para>
-</entry><entry
- align="char">
-<para>fd is not a valid open file descriptor.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EINTERNAL</para>
-</entry><entry
- align="char">
-<para>Internal error.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EINVAL</para>
-</entry><entry
- align="char">
-<para>Illegal input parameter.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
 
 </section><section id="AUDIO_SET_BYPASS_MODE"
 role="subsection"><title>AUDIO_SET_BYPASS_MODE</title>
@@ -859,28 +725,6 @@ role="subsection"><title>AUDIO_SET_BYPASS_MODE</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 &return-value-dvb;
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>EBADF</para>
-</entry><entry
- align="char">
-<para>fd is not a valid open file descriptor.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EINTERNAL</para>
-</entry><entry
- align="char">
-<para>Internal error.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EINVAL</para>
-</entry><entry
- align="char">
-<para>Illegal input parameter.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
 
 </section><section id="AUDIO_CHANNEL_SELECT"
 role="subsection"><title>AUDIO_CHANNEL_SELECT</title>
@@ -927,28 +771,6 @@ role="subsection"><title>AUDIO_CHANNEL_SELECT</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 &return-value-dvb;
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>EBADF</para>
-</entry><entry
- align="char">
-<para>fd is not a valid open file descriptor.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EINTERNAL</para>
-</entry><entry
- align="char">
-<para>Internal error.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EINVAL</para>
-</entry><entry
- align="char">
-<para>Illegal input parameter ch.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
 
 </section><section id="AUDIO_GET_STATUS"
 role="subsection"><title>AUDIO_GET_STATUS</title>
@@ -994,28 +816,6 @@ role="subsection"><title>AUDIO_GET_STATUS</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 &return-value-dvb;
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>EBADF</para>
-</entry><entry
- align="char">
-<para>fd is not a valid open file descriptor.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EINTERNAL</para>
-</entry><entry
- align="char">
-<para>Internal error.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EFAULT</para>
-</entry><entry
- align="char">
-<para>status points to invalid address.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
 
 </section><section id="AUDIO_GET_CAPABILITIES"
 role="subsection"><title>AUDIO_GET_CAPABILITIES</title>
@@ -1061,28 +861,6 @@ role="subsection"><title>AUDIO_GET_CAPABILITIES</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 &return-value-dvb;
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>EBADF</para>
-</entry><entry
- align="char">
-<para>fd is not a valid open file descriptor.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EINTERNAL</para>
-</entry><entry
- align="char">
-<para>Internal error.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EFAULT</para>
-</entry><entry
- align="char">
-<para>cap points to an invalid address.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
 
 </section><section id="AUDIO_CLEAR_BUFFER"
 role="subsection"><title>AUDIO_CLEAR_BUFFER</title>
@@ -1119,21 +897,6 @@ role="subsection"><title>AUDIO_CLEAR_BUFFER</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 &return-value-dvb;
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>EBADF</para>
-</entry><entry
- align="char">
-<para>fd is not a valid open file descriptor.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EINTERNAL</para>
-</entry><entry
- align="char">
-<para>Internal error.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
 
 </section><section id="AUDIO_SET_ID"
 role="subsection"><title>AUDIO_SET_ID</title>
@@ -1182,28 +945,6 @@ role="subsection"><title>AUDIO_SET_ID</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 &return-value-dvb;
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>EBADF</para>
-</entry><entry
- align="char">
-<para>fd is not a valid open file descriptor.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EINTERNAL</para>
-</entry><entry
- align="char">
-<para>Internal error.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EINVAL</para>
-</entry><entry
- align="char">
-<para>Invalid sub-stream id.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
 
 </section><section id="AUDIO_SET_MIXER"
 role="subsection"><title>AUDIO_SET_MIXER</title>
@@ -1247,28 +988,6 @@ role="subsection"><title>AUDIO_SET_MIXER</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 &return-value-dvb;
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>EBADF</para>
-</entry><entry
- align="char">
-<para>fd is not a valid open file descriptor.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EINTERNAL</para>
-</entry><entry
- align="char">
-<para>Internal error.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EFAULT</para>
-</entry><entry
- align="char">
-<para>mix points to an invalid address.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
 
 </section><section id="AUDIO_SET_STREAMTYPE"
 role="subsection"><title>AUDIO_SET_STREAMTYPE</title>
@@ -1316,13 +1035,6 @@ role="subsection"><title>AUDIO_SET_STREAMTYPE</title>
 &return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
-<para>EBADF</para>
-</entry><entry
- align="char">
-<para>fd is not a valid open file descriptor</para>
-</entry>
- </row><row><entry
- align="char">
 <para>EINVAL</para>
 </entry><entry
  align="char">
@@ -1375,13 +1087,6 @@ role="subsection"><title>AUDIO_SET_EXT_ID</title>
 &return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
-<para>EBADF</para>
-</entry><entry
- align="char">
-<para>fd is not a valid open file descriptor</para>
-</entry>
- </row><row><entry
- align="char">
 <para>EINVAL</para>
 </entry><entry
  align="char">
@@ -1435,13 +1140,6 @@ role="subsection"><title>AUDIO_SET_ATTRIBUTES</title>
 &return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
-<para>EBADF</para>
-</entry><entry
- align="char">
-<para>fd is not a valid open file descriptor</para>
-</entry>
- </row><row><entry
- align="char">
 <para>EINVAL</para>
 </entry><entry
  align="char">
@@ -1495,13 +1193,6 @@ role="subsection"><title>AUDIO_SET_KARAOKE</title>
 &return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
-<para>EBADF</para>
-</entry><entry
- align="char">
-<para>fd is not a valid open file descriptor</para>
-</entry>
- </row><row><entry
- align="char">
 <para>EINVAL</para>
 </entry><entry
  align="char">
diff --git a/Documentation/DocBook/media/v4l/gen-errors.xml b/Documentation/DocBook/media/v4l/gen-errors.xml
index 2b50b63..9a9575f 100644
--- a/Documentation/DocBook/media/v4l/gen-errors.xml
+++ b/Documentation/DocBook/media/v4l/gen-errors.xml
@@ -35,6 +35,10 @@
 	       descriptor is not for a media device.</entry>
       </row>
       <row>
+        <entry>ENODEV</entry>
+	<entry>Device not found or was removed.</entry>
+      </row>
+      <row>
 	<entry>ENOMEM</entry>
 	<entry>There's not enough memory to handle the desired operation.</entry>
       </row>
-- 
1.7.1


