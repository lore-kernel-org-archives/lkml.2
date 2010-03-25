Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab0CYS3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 14:29:16 -0400
Received: from web94908.mail.in2.yahoo.com ([203.104.17.164]:37824 "HELO
	web94908.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753974Ab0CYS3O convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 14:29:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=MUaaXglVpH1Ql+MU4PoRmUkEfzSwkdWGBlIfQ+lI2S+ZHIV+FOA12/ETRCuujS3HHDStFx1vv7jAdGxmq3+Sgkxv4nS3wGLHkymY/77aNrqt/HXMbZbaRET7mau5jRpdFeTz/rwvqF/XZle/letxL+y707C7wY+fvq/C3G2pVp4=;
Message-ID: <938191.86865.qm@web94908.mail.in2.yahoo.com>
X-YMail-OSG: mNxqtmcVM1nd.2mUZ8VzN.fjKaqx3_n9UdZf2A1vzACwiIv
 CxWPfaJ9LQN2O3XZ3PYVyklXB1osRNIYN4g.7jkr5jKaeWgvAKbfoo5vRVE5
 WWl8BDWFgGuvH23lguhr9F22G79Z7YSIzuRieAAMeXBG9I62K3TH8NG_LEEi
 2LcZ6ghLYorXtIKuojvrPwyHRB748BANXJFOU_pJyNCYaq8Ovqz3sqtCozCp
 YLrtbv2SWy4A1.LHdZuuLVvBtLEerPeMgrZQVupkJHk3EF7qD6Ikl4WaP3EX
 O7P3VI4OksKfhlyJXH7glu_v1iVybcZ0_
X-Mailer: YahooMailClassic/10.0.8 YahooMailWebService/0.8.100.260964
Date: Thu, 25 Mar 2010 23:59:08 +0530 (IST)
From: Pavan Savoy <pavan_savoy@yahoo.co.in>
Subject: rfkill events from kernel space
To: Johannes Berg <johannes@sipsolutions.net>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How do I send an rfkill event upon device /dev/rfkill from kernel space ?

An action upon my driver, should break the poll on /dev/rfkill from a user-space daemon, but sending an OP_CHANGE event.

As I've seen only writing blocked/non-blocked on the sysfs entry of an rfkill device generates an rfkill event.


      Your Mail works best with the New Yahoo Optimized IE8. Get it NOW! http://downloads.yahoo.com/in/internetexplorer/
