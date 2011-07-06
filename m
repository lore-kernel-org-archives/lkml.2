Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab1GFSEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 14:04:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996Ab1GFSEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 14:04:20 -0400
Date: Wed, 6 Jul 2011 15:03:56 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH RFCv3 10/17] [media] DVB: Point to the generic error chapter
Message-ID: <20110706150356.3a3cdf94@pedra>
In-Reply-To: <cover.1309974026.git.mchehab@redhat.com>
References: <cover.1309974026.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just like the V4L, MC and LIRC API's, point to the generic error
chapter for ioctl's. This will allow moving generic error codes
to just one place inside all media API's.

A latter patch will remove the generic errors from each specific
ioctl.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media/dvb/audio.xml b/Documentation/DocBook/media/dvb/audio.xml
index c27fe73..90e9b7f 100644
--- a/Documentation/DocBook/media/dvb/audio.xml
+++ b/Documentation/DocBook/media/dvb/audio.xml
@@ -220,8 +220,7 @@ and right.
 <para>(blocking mode is the default)</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+<para>RETURN VALUE</para>
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>ENODEV</para>
@@ -279,8 +278,7 @@ and right.
 <para>File descriptor returned by a previous call to open().</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+<para>RETURN VALUE</para>
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -335,8 +333,7 @@ and right.
 <para>Size of buf.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+<para>RETURN VALUE</para>
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EPERM</para>
@@ -394,8 +391,7 @@ role="subsection"><title>AUDIO_STOP</title>
 <para>Equals AUDIO_STOP for this command.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -446,8 +442,7 @@ role="subsection"><title>AUDIO_PLAY</title>
 <para>Equals AUDIO_PLAY for this command.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -506,8 +501,7 @@ role="subsection"><title>AUDIO_PAUSE</title>
 <para>Equals AUDIO_PAUSE for this command.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -563,8 +557,7 @@ with AUDIO_PAUSE command.</para>
 <para>Equals AUDIO_CONTINUE for this command.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -627,8 +620,7 @@ role="subsection"><title>AUDIO_SELECT_SOURCE</title>
  stream.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -706,8 +698,7 @@ role="subsection"><title>AUDIO_SET_MUTE</title>
 <para>FALSE Audio Un-mute</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -785,8 +776,7 @@ role="subsection"><title>AUDIO_SET_AV_SYNC</title>
 <para>FALSE AV-sync OFF</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -868,8 +858,7 @@ role="subsection"><title>AUDIO_SET_BYPASS_MODE</title>
 <para>FALSE Bypass is enabled</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -937,8 +926,7 @@ role="subsection"><title>AUDIO_CHANNEL_SELECT</title>
  stereo).</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -1005,8 +993,7 @@ role="subsection"><title>AUDIO_GET_STATUS</title>
 <para>Returns the current state of Audio Device.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -1073,8 +1060,7 @@ role="subsection"><title>AUDIO_GET_CAPABILITIES</title>
 <para>Returns a bit array of supported sound formats.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -1132,8 +1118,7 @@ role="subsection"><title>AUDIO_CLEAR_BUFFER</title>
 <para>Equals AUDIO_CLEAR_BUFFER for this command.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -1196,8 +1181,7 @@ role="subsection"><title>AUDIO_SET_ID</title>
 <para>audio sub-stream id</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -1262,8 +1246,7 @@ role="subsection"><title>AUDIO_SET_MIXER</title>
 <para>mixer settings.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -1330,8 +1313,7 @@ role="subsection"><title>AUDIO_SET_STREAMTYPE</title>
 <para>stream type</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -1390,8 +1372,7 @@ role="subsection"><title>AUDIO_SET_EXT_ID</title>
 <para>audio sub_stream_id</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -1451,8 +1432,7 @@ role="subsection"><title>AUDIO_SET_ATTRIBUTES</title>
 <para>audio attributes according to section ??</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -1512,8 +1492,7 @@ role="subsection"><title>AUDIO_SET_KARAOKE</title>
 <para>karaoke settings according to section ??.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
diff --git a/Documentation/DocBook/media/dvb/ca.xml b/Documentation/DocBook/media/dvb/ca.xml
index a6cb952..5c4adb4 100644
--- a/Documentation/DocBook/media/dvb/ca.xml
+++ b/Documentation/DocBook/media/dvb/ca.xml
@@ -158,8 +158,7 @@ typedef struct ca_pid {
 <para>(blocking mode is the default)</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+<para>RETURN VALUE</para>
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>ENODEV</para>
@@ -217,8 +216,7 @@ typedef struct ca_pid {
 <para>File descriptor returned by a previous call to open().</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+<para>RETURN VALUE</para>
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
diff --git a/Documentation/DocBook/media/dvb/demux.xml b/Documentation/DocBook/media/dvb/demux.xml
index 6758739..e5058d7 100644
--- a/Documentation/DocBook/media/dvb/demux.xml
+++ b/Documentation/DocBook/media/dvb/demux.xml
@@ -239,8 +239,7 @@ typedef enum {
 <para>(blocking mode is the default)</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+<para>RETURN VALUE</para>
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>ENODEV</para>
@@ -299,8 +298,7 @@ typedef enum {
 <para>File descriptor returned by a previous call to open().</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+<para>RETURN VALUE</para>
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -381,8 +379,7 @@ typedef enum {
 <para>Size of buf.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+<para>RETURN VALUE</para>
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EWOULDBLOCK</para>
@@ -485,8 +482,7 @@ typedef enum {
 <para>Size of buf.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+<para>RETURN VALUE</para>
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EWOULDBLOCK</para>
@@ -553,8 +549,7 @@ typedef enum {
 <para>Equals DMX_START for this command.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -619,8 +614,7 @@ typedef enum {
 <para>Equals DMX_STOP for this command.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -682,8 +676,7 @@ typedef enum {
 <para>Pointer to structure containing filter parameters.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -755,8 +748,7 @@ typedef enum {
 <para>Pointer to structure containing filter parameters.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -827,8 +819,7 @@ typedef enum {
 <para>Size of circular buffer.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -900,8 +891,7 @@ typedef enum {
 <para>Pointer to the location where the event is to be stored.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -974,8 +964,7 @@ typedef enum {
 <para>Pointer to the location where the stc is to be stored.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index caec58c..33274bc 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -80,7 +80,7 @@ struct dtv_properties {
 <para>Points to the location where the front-end property commands are stored.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row>
   <entry align="char"><para>EINVAL</para></entry>
   <entry align="char"><para>Invalid parameter(s) received or number of parameters out of the range.</para></entry>
@@ -137,8 +137,7 @@ struct dtv_properties {
 <para>Points to the location where the front-end property commands are stored.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row>
   <entry align="char"><para>EINVAL</para></entry>
   <entry align="char"><para>Invalid parameter(s) received or number of parameters out of the range.</para></entry>
diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index 304d54e..c5a5cb4 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -515,8 +515,7 @@ typedef enum fe_hierarchy {
 <para>(blocking mode is the default)</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+<para>RETURN VALUE</para>
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>ENODEV</para>
@@ -576,8 +575,7 @@ typedef enum fe_hierarchy {
 <para>File descriptor returned by a previous call to open().</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -633,8 +631,7 @@ typedef enum fe_hierarchy {
  to be stored.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+<para>RETURN VALUE</para>
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -695,8 +692,7 @@ typedef enum fe_hierarchy {
 <para>The bit error rate is stored into *ber.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -773,8 +769,7 @@ typedef enum fe_hierarchy {
 </entry>
  </row></tbody></tgroup></informaltable>
 
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -851,8 +846,7 @@ typedef enum fe_hierarchy {
 <para>The signal strength value is stored into *strength.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -936,8 +930,7 @@ typedef enum fe_hierarchy {
  so far.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -1012,8 +1005,7 @@ typedef enum fe_hierarchy {
 <para>Points to parameters for tuning operation.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -1085,8 +1077,7 @@ typedef enum fe_hierarchy {
 </entry>
  </row></tbody></tgroup></informaltable>
 
-<para>ERRORS
-</para>
+&return-value-dvb;
 
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
@@ -1187,8 +1178,7 @@ typedef enum fe_hierarchy {
 </entry>
  </row></tbody></tgroup></informaltable>
 
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -1273,8 +1263,7 @@ typedef enum fe_hierarchy {
  to be stored.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -1332,8 +1321,7 @@ typedef enum fe_hierarchy {
 </entry>
  </row></tbody></tgroup></informaltable>
 
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -1405,8 +1393,7 @@ typedef enum fe_hierarchy {
 </entry>
  </row></tbody></tgroup></informaltable>
 
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -1493,8 +1480,7 @@ typedef enum fe_hierarchy {
 <para>Pointer to the command to be received.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -1579,8 +1565,7 @@ typedef enum fe_hierarchy {
 </entry>
  </row></tbody></tgroup></informaltable>
 
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -1663,8 +1648,7 @@ typedef enum fe_hierarchy {
 <para>The requested tone generation mode (on/off).</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>ENODEV</para>
@@ -1748,8 +1732,7 @@ typedef enum fe_hierarchy {
 </entry>
  </row></tbody></tgroup></informaltable>
 
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>ENODEV</para>
@@ -1834,8 +1817,7 @@ typedef enum fe_hierarchy {
 </entry>
  </row></tbody></tgroup></informaltable>
 
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>ENODEV</para>
@@ -1903,7 +1885,7 @@ FE_TUNE_MODE_ONESHOT When set, this flag will disable any zigzagging or other "n
 </entry>
  </row></tbody></tgroup></informaltable>
 
-<para>ERRORS</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row>
 <entry align="char"><para>EINVAL</para></entry>
 <entry align="char"><para>Invalid argument.</para></entry>
@@ -1941,7 +1923,7 @@ sends the specified raw cmd to the dish via DISEqC.
 </entry>
  </row></tbody></tgroup></informaltable>
 
-<para>ERRORS</para>
+&return-value-dvb;
 <informaltable><tgroup cols="1"><tbody><row>
 <entry align="char">
 	<para>There are no errors in use for this call</para>
diff --git a/Documentation/DocBook/media/dvb/video.xml b/Documentation/DocBook/media/dvb/video.xml
index 539c79b..0b1b662 100644
--- a/Documentation/DocBook/media/dvb/video.xml
+++ b/Documentation/DocBook/media/dvb/video.xml
@@ -399,8 +399,7 @@ VIDEO_GET_NAVI:
 <para>(blocking mode is the default)</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+<para>RETURN VALUE</para>
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>ENODEV</para>
@@ -458,8 +457,7 @@ VIDEO_GET_NAVI:
 <para>File descriptor returned by a previous call to open().</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+<para>RETURN VALUE</para>
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -514,8 +512,7 @@ VIDEO_GET_NAVI:
 <para>Size of buf.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+<para>RETURN VALUE</para>
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EPERM</para>
@@ -595,8 +592,7 @@ role="subsection"><title>VIDEO_STOP</title>
 <para>FALSE: Show last decoded frame.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -648,8 +644,7 @@ role="subsection"><title>VIDEO_PLAY</title>
 <para>Equals VIDEO_PLAY for this command.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -705,8 +700,7 @@ role="subsection"><title>VIDEO_FREEZE</title>
 <para>Equals VIDEO_FREEZE for this command.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -758,8 +752,7 @@ role="subsection"><title>VIDEO_CONTINUE</title>
 <para>Equals VIDEO_CONTINUE for this command.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -821,8 +814,7 @@ role="subsection"><title>VIDEO_SELECT_SOURCE</title>
 <para>Indicates which source shall be used for the Video stream.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -887,8 +879,7 @@ role="subsection"><title>VIDEO_SET_BLANK</title>
 <para>FALSE: Show last decoded frame.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -955,8 +946,7 @@ role="subsection"><title>VIDEO_GET_STATUS</title>
 <para>Returns the current status of the Video Device.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -1032,8 +1022,7 @@ role="subsection"><title>VIDEO_GET_EVENT</title>
  stored.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -1115,8 +1104,7 @@ role="subsection"><title>VIDEO_SET_DISPLAY_FORMAT</title>
 <para>Selects the video format to be used.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -1185,8 +1173,7 @@ role="subsection"><title>VIDEO_STILLPICTURE</title>
 <para>Pointer to a location where an I-frame and size is stored.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -1252,8 +1239,7 @@ role="subsection"><title>VIDEO_FAST_FORWARD</title>
 <para>The number of frames to skip.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -1326,8 +1312,7 @@ role="subsection"><title>VIDEO_SLOWMOTION</title>
 <para>The number of times to repeat each frame.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -1402,8 +1387,7 @@ role="subsection"><title>VIDEO_GET_CAPABILITIES</title>
  information.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -1462,8 +1446,7 @@ role="subsection"><title>VIDEO_SET_ID</title>
 <para>video sub-stream id</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -1520,8 +1503,7 @@ role="subsection"><title>VIDEO_CLEAR_BUFFER</title>
 <para>Equals VIDEO_CLEAR_BUFFER for this command.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -1574,8 +1556,7 @@ role="subsection"><title>VIDEO_SET_STREAMTYPE</title>
 <para>stream type</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -1635,8 +1616,7 @@ role="subsection"><title>VIDEO_SET_FORMAT</title>
 <para>video format of TV as defined in section ??.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -1697,8 +1677,7 @@ role="subsection"><title>VIDEO_SET_SYSTEM</title>
 <para>video system of TV output.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -1757,8 +1736,7 @@ role="subsection"><title>VIDEO_SET_HIGHLIGHT</title>
 <para>SPU Highlight information according to section ??.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -1818,8 +1796,7 @@ role="subsection"><title>VIDEO_SET_SPU</title>
  to section ??.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -1879,8 +1856,7 @@ role="subsection"><title>VIDEO_SET_SPU_PALETTE</title>
 <para>SPU palette according to section ??.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -1941,8 +1917,7 @@ role="subsection"><title>VIDEO_GET_NAVI</title>
  ??.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -2003,8 +1978,7 @@ role="subsection"><title>VIDEO_SET_ATTRIBUTES</title>
 <para>video attributes according to section ??.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-<para>ERRORS
-</para>
+&return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
diff --git a/Documentation/DocBook/media_api.tmpl b/Documentation/DocBook/media_api.tmpl
index bdb06bc..c3eeca7 100644
--- a/Documentation/DocBook/media_api.tmpl
+++ b/Documentation/DocBook/media_api.tmpl
@@ -9,6 +9,7 @@
 <!ENTITY fd                     "File descriptor returned by <link linkend='func-open'><function>open()</function></link>.">
 <!ENTITY i2c                    "I<superscript>2</superscript>C">
 <!ENTITY return-value		"<title>Return Value</title><para>On success <returnvalue>0</returnvalue> is returned, on error <returnvalue>-1</returnvalue> and the <varname>errno</varname> variable is set appropriately. The generic error codes are described at the <link linkend='gen-errors'>Generic Error Codes</link> chapter.</para>">
+<!ENTITY return-value-dvb	"<para>RETURN VALUE</para><para>On success <returnvalue>0</returnvalue> is returned, on error <returnvalue>-1</returnvalue> and the <varname>errno</varname> variable is set appropriately. The generic error codes are described at the <link linkend='gen-errors'>Generic Error Codes</link> chapter.</para>">
 <!ENTITY manvol                 "<manvolnum>2</manvolnum>">
 
 <!-- Table templates: structs, structs w/union, defines. -->
-- 
1.7.1


