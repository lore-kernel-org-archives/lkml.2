Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab1GFSEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 14:04:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755361Ab1GFSEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 14:04:39 -0400
Date: Wed, 6 Jul 2011 15:04:03 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH RFCv3 15/17] [media] DocBook/dvb: Use generic descriptions
 for the video API
Message-ID: <20110706150403.52c2279c@pedra>
In-Reply-To: <cover.1309974026.git.mchehab@redhat.com>
References: <cover.1309974026.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While here, removes the bogus EINTERNAL error codes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media/dvb/video.xml b/Documentation/DocBook/media/dvb/video.xml
index 0b1b662..25fb823 100644
--- a/Documentation/DocBook/media/dvb/video.xml
+++ b/Documentation/DocBook/media/dvb/video.xml
@@ -593,22 +593,6 @@ role="subsection"><title>VIDEO_STOP</title>
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
-<para>Internal error, possibly in the communication with the
- DVB subsystem.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
 
 </section><section id="VIDEO_PLAY"
 role="subsection"><title>VIDEO_PLAY</title>
@@ -645,22 +629,6 @@ role="subsection"><title>VIDEO_PLAY</title>
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
-<para>Internal error, possibly in the communication with the
- DVB subsystem.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
 
 </section><section id="VIDEO_FREEZE"
 role="subsection"><title>VIDEO_FREEZE</title>
@@ -701,22 +669,6 @@ role="subsection"><title>VIDEO_FREEZE</title>
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
-<para>Internal error, possibly in the communication with the
- DVB subsystem.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
 
 </section><section id="VIDEO_CONTINUE"
 role="subsection"><title>VIDEO_CONTINUE</title>
@@ -753,22 +705,6 @@ role="subsection"><title>VIDEO_CONTINUE</title>
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
-<para>Internal error, possibly in the communication with the
- DVB subsystem.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
 
 </section><section id="VIDEO_SELECT_SOURCE"
 role="subsection"><title>VIDEO_SELECT_SOURCE</title>
@@ -815,22 +751,6 @@ role="subsection"><title>VIDEO_SELECT_SOURCE</title>
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
-<para>Internal error, possibly in the communication with the
- DVB subsystem.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
 
 </section><section id="VIDEO_SET_BLANK"
 role="subsection"><title>VIDEO_SET_BLANK</title>
@@ -880,29 +800,6 @@ role="subsection"><title>VIDEO_SET_BLANK</title>
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
-<para>Internal error, possibly in the communication with the
- DVB subsystem.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EINVAL</para>
-</entry><entry
- align="char">
-<para>Illegal input parameter</para>
-</entry>
- </row></tbody></tgroup></informaltable>
 
 </section><section id="VIDEO_GET_STATUS"
 role="subsection"><title>VIDEO_GET_STATUS</title>
@@ -947,29 +844,6 @@ role="subsection"><title>VIDEO_GET_STATUS</title>
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
-<para>Internal error, possibly in the communication with the
- DVB subsystem.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EFAULT</para>
-</entry><entry
- align="char">
-<para>status points to invalid address</para>
-</entry>
- </row></tbody></tgroup></informaltable>
 
 </section><section id="VIDEO_GET_EVENT"
 role="subsection"><title>VIDEO_GET_EVENT</title>
@@ -1025,20 +899,6 @@ role="subsection"><title>VIDEO_GET_EVENT</title>
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
-<para>EFAULT</para>
-</entry><entry
- align="char">
-<para>ev points to invalid address</para>
-</entry>
- </row><row><entry
- align="char">
 <para>EWOULDBLOCK</para>
 </entry><entry
  align="char">
@@ -1050,11 +910,6 @@ role="subsection"><title>VIDEO_GET_EVENT</title>
 <para>EOVERFLOW</para>
 </entry><entry
  align="char">
-</entry>
- </row><row><entry
- align="char">
-</entry><entry
- align="char">
 <para>Overflow in event queue - one or more events were lost.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
@@ -1105,28 +960,6 @@ role="subsection"><title>VIDEO_SET_DISPLAY_FORMAT</title>
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
- </row><row><entry
- align="char">
-<para>EINVAL</para>
-</entry><entry
- align="char">
-<para>Illegal parameter format.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
 
 </section><section id="VIDEO_STILLPICTURE"
 role="subsection"><title>VIDEO_STILLPICTURE</title>
@@ -1174,28 +1007,6 @@ role="subsection"><title>VIDEO_STILLPICTURE</title>
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
- </row><row><entry
- align="char">
-<para>EFAULT</para>
-</entry><entry
- align="char">
-<para>sp points to an invalid iframe.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
 
 </section><section id="VIDEO_FAST_FORWARD"
 role="subsection"><title>VIDEO_FAST_FORWARD</title>
@@ -1242,32 +1053,11 @@ role="subsection"><title>VIDEO_FAST_FORWARD</title>
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
-<para>EINTERNAL</para>
-</entry><entry
- align="char">
-<para>Internal error.</para>
-</entry>
- </row><row><entry
- align="char">
 <para>EPERM</para>
 </entry><entry
  align="char">
 <para>Mode VIDEO_SOURCE_MEMORY not selected.</para>
 </entry>
- </row><row><entry
- align="char">
-<para>EINVAL</para>
-</entry><entry
- align="char">
-<para>Illegal parameter format.</para>
-</entry>
  </row></tbody></tgroup></informaltable>
 
 </section><section id="VIDEO_SLOWMOTION"
@@ -1315,32 +1105,11 @@ role="subsection"><title>VIDEO_SLOWMOTION</title>
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
-<para>EINTERNAL</para>
-</entry><entry
- align="char">
-<para>Internal error.</para>
-</entry>
- </row><row><entry
- align="char">
 <para>EPERM</para>
 </entry><entry
  align="char">
 <para>Mode VIDEO_SOURCE_MEMORY not selected.</para>
 </entry>
- </row><row><entry
- align="char">
-<para>EINVAL</para>
-</entry><entry
- align="char">
-<para>Illegal parameter format.</para>
-</entry>
  </row></tbody></tgroup></informaltable>
 
 </section><section id="VIDEO_GET_CAPABILITIES"
@@ -1388,21 +1157,6 @@ role="subsection"><title>VIDEO_GET_CAPABILITIES</title>
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
-<para>EFAULT</para>
-</entry><entry
- align="char">
-<para>cap points to an invalid iframe.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
 
 </section><section id="VIDEO_SET_ID"
 role="subsection"><title>VIDEO_SET_ID</title>
@@ -1449,20 +1203,6 @@ role="subsection"><title>VIDEO_SET_ID</title>
 &return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
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
 <para>EINVAL</para>
 </entry><entry
  align="char">
@@ -1504,14 +1244,6 @@ role="subsection"><title>VIDEO_CLEAR_BUFFER</title>
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
- </row></tbody></tgroup></informaltable>
 
 </section><section id="VIDEO_SET_STREAMTYPE"
 role="subsection"><title>VIDEO_SET_STREAMTYPE</title>
@@ -1557,21 +1289,6 @@ role="subsection"><title>VIDEO_SET_STREAMTYPE</title>
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
-<para>EINVAL</para>
-</entry><entry
- align="char">
-<para>type is not a valid or supported stream type.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
 
 </section><section id="VIDEO_SET_FORMAT"
 role="subsection"><title>VIDEO_SET_FORMAT</title>
@@ -1619,13 +1336,6 @@ role="subsection"><title>VIDEO_SET_FORMAT</title>
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
@@ -1680,13 +1390,6 @@ role="subsection"><title>VIDEO_SET_SYSTEM</title>
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
@@ -1737,21 +1440,6 @@ role="subsection"><title>VIDEO_SET_HIGHLIGHT</title>
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
-<para>EINVAL</para>
-</entry><entry
- align="char">
-<para>input is not a valid highlight setting.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
 
 </section><section id="VIDEO_SET_SPU"
 role="subsection"><title>VIDEO_SET_SPU</title>
@@ -1799,13 +1487,6 @@ role="subsection"><title>VIDEO_SET_SPU</title>
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
@@ -1859,13 +1540,6 @@ role="subsection"><title>VIDEO_SET_SPU_PALETTE</title>
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
@@ -1920,13 +1594,6 @@ role="subsection"><title>VIDEO_GET_NAVI</title>
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
 <para>EFAULT</para>
 </entry><entry
  align="char">
@@ -1981,13 +1648,6 @@ role="subsection"><title>VIDEO_SET_ATTRIBUTES</title>
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
-- 
1.7.1


