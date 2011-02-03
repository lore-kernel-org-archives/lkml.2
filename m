Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335Ab1BCQk6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 11:40:58 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43241 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756370Ab1BCQk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 11:40:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=g6aeCEHL8+SOgcWzy5Php0G5swIp/fbCUXOPoxuv4TVuOSZoWo43tClXYQq+eV4Op6
         niPPqzRN8xshnowmWsbYZwPtQoG4sm6n2tW9esbKx3CUEaf20qV5NELyF5DTlBLC7on7
         V3qUtlSCnZo/MVHR4Z7Icijn+O9aRK0oHZGTE=
Date: Fri, 4 Feb 2011 00:40:50 +0800
From: Harry Wei <harryxiyou@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com
Subject: [PATCH]Translated the Documentation/SecurityBugs into Chinese
Message-ID: <20110203164049.GA4379@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi us,
   I translated the linux-2.6.37/Documentation/SecurityBugs into Chinese.

Signed-off-by: Harry Wei
---
 Documentation/zh_CN/SecurityBugs |   53 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 53 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/zh_CN/SecurityBugs

diff --git a/Documentation/zh_CN/SecurityBugs b/Documentation/zh_CN/SecurityBugs
new file mode 100644
index 0000000..ca5786b
--- /dev/null
+++ b/Documentation/zh_CN/SecurityBugs
@@ -0,0 +1,50 @@
+Chinese translated version of Documentation/SecurityBugs
+
+If you have any comment or update to the content, please contact the
+original document maintainer directly.  However, if you have a problem
+communicating in English you can also ask the Chinese maintainer for
+help.  Contact the Chinese maintainer if this translation is outdated
+or if there is a problem with the translation.
+
+Chinese maintainer: Harry Wei <harryxiyou@gmail.com>
+---------------------------------------------------------------------
+Documentation/SecurityBugs �����ķ���
+
+���������ۻ����±��ĵ����ݣ���ֱ����ϵԭ�ĵ���ά���ߡ�������ʹ��Ӣ��
+���������ѵĻ���Ҳ���������İ�ά�����������������������²���ʱ���߷�
+���������⣬����ϵ���İ�ά���ߡ�
+
+���İ�ά���ߣ� ������ Harry Wei <harryxiyou@gmail.com>
+���İ淭���ߣ� ������ Harry Wei <harryxiyou@gmail.com>
+���İ�У���ߣ� ������ Harry Wei <harryxiyou@gmail.com>
+
+
+����Ϊ����
+---------------------------------------------------------------------
+Linux�ں˿�������Ϊ��ȫ�ǳ���Ҫ�����ˣ�������Ҫ֪����һ���й���
+��ȫ��©�������ֵ�ʱ�򣬲��������ܻᱻ�������޸����߹���������������ȫ
+©��������Linux�ں˰�ȫ�Ŷӡ�
+
+1) ��ϵ
+
+linux�ں˰�ȫ�Ŷӿ���ͨ��email<security@kernel.org>����ϵ������
+һ�������İ�ȫ������Ա�����԰�������©�����沢�ҹ�����ȡ��һ���޸�����
+ȫ�Ŷ��п��ܻ��Ӳ��ֵ�ά�����������������İ�����?˽Ⲣ���޸���ȫ©����
+�������κ�©���������ṩ����ϢԽ����Խ�����Ϻ��޸��������㲻����ʲô
+���а�������Ϣ���Ǿ�������һ��REPORTING-BUGS�ļ��еĸ������̡���
+�ι����ԵĴ��붼�Ƿǳ����õģ�δ�������ߵ�ͬ�ⲻ�ᱻȡ�����������Ѿ�
+���������ڡ�
+
+2) ����
+
+Linux�ں˰�ȫ�Ŷӵ���ּ���Ǻ�©���ύ��һ������©���Ľ�������ֱ
+������������ϲ����������ȫ����©������һ��©�������޸���û�б���ȫ����
+�⣬��������û��ͨ�����Ի��߹�Ӧ��Э�������Ժ������ӳٹ�����Ȼ��������
+������Щ�ӳپ����ܵĶ�Щ���ǿ����ļ��죬�����Ǽ������ڻ��߼����¡�����
+������ͨ����ȫ�ŶӺ�©���ṩ���Լ���Ӧ��Ǣ̸���Ľ���������ʱ�����ǴӺ�
+�̣������ģ����Ѿ���������֪�������������ڡ���Ϊһ��������Ĭ�����ߣ���
+��������֪ͨ���ڵ�������7���İ��š�
+
+3) 
