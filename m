Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900Ab2H0NqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 09:46:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50286 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab2H0NqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 09:46:07 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] target: iscsi: Fix typo in target/iscsi drivers
Date: Mon, 27 Aug 2012 22:46:00 +0900
Message-Id: <1346075160-4681-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.12.rc3.4.g91e4bfe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in printk and comment within target/iscsi drivers

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/target/iscsi/iscsi_target_configfs.c   | 2 +-
 drivers/target/iscsi/iscsi_target_erl0.c       | 6 +++---
 drivers/target/iscsi/iscsi_target_parameters.c | 4 ++--
 drivers/target/iscsi/iscsi_target_util.c       | 2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index a7b25e7..ebd73da 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -235,7 +235,7 @@ struct se_tpg_np *lio_target_call_addnptotpg(
 	 * iSER/SCTP (TODO, software emulation with osc-iwarp)
 	 * iSER/IB (TODO, hardware available)
 	 *
-	 * can be enabled with atributes under
+	 * can be enabled with attributes under
 	 * sys/kernel/config/iscsi/$IQN/$TPG/np/$IP:$PORT/
 	 *
 	 */
diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/iscsi/iscsi_target_erl0.c
index 1a02016..117520e 100644
--- a/drivers/target/iscsi/iscsi_target_erl0.c
+++ b/drivers/target/iscsi/iscsi_target_erl0.c
@@ -408,11 +408,11 @@ static int iscsit_dataout_pre_datapduinorder_yes(
 	/*
 	 * For DataSequenceInOrder=Yes: If the offset is greater than the global
 	 * DataPDUInOrder=Yes offset counter in struct iscsi_cmd a protcol error has
-	 * occured and fail the connection.
+	 * occurred and fail the connection.
 	 *
 	 * For DataSequenceInOrder=No: If the offset is greater than the per
 	 * sequence DataPDUInOrder=Yes offset counter in struct iscsi_seq a protocol
-	 * error has occured and fail the connection.
+	 * error has occurred and fail the connection.
 	 */
 	if (conn->sess->sess_ops->DataSequenceInOrder) {
 		if (hdr->offset != cmd->write_data_done) {
@@ -793,7 +793,7 @@ extern void iscsit_start_time2retain_handler(struct iscsi_session *sess)
 {
 	int tpg_active;
 	/*
-	 * Only start Time2Retain timer when the assoicated TPG is still in
+	 * Only start Time2Retain timer when the associated TPG is still in
 	 * an ACTIVE (eg: not disabled or shutdown) state.
 	 */
 	spin_lock(&ISCSI_TPG_S(sess)->tpg_state_lock);
diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index 0c4760f..240f7aa 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -662,7 +662,7 @@ int iscsi_extract_key_value(char *textbuf, char **key, char **value)
 {
 	*value = strchr(textbuf, '=');
 	if (!*value) {
-		pr_err("Unable to locate \"=\" seperator for key,"
+		pr_err("Unable to locate \"=\" separator for key,"
 				" ignoring request.\n");
 		return -1;
 	}
@@ -1269,7 +1269,7 @@ static int iscsi_check_value(struct iscsi_param *param, char *value)
 		comma_ptr = strchr(value, ',');
 
 		if (comma_ptr && !IS_TYPE_VALUE_LIST(param)) {
-			pr_err("Detected value seperator \",\", but"
+			pr_err("Detected value separator \",\", but"
 				" key \"%s\" does not allow a value list,"
 				" protocol error.\n", param->name);
 			return -1;
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index b42cdeb..53c8563 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -666,7 +666,7 @@ void iscsit_release_cmd(struct iscsi_cmd *cmd)
 void iscsit_free_cmd(struct iscsi_cmd *cmd)
 {
 	/*
-	 * Determine if a struct se_cmd is assoicated with
+	 * Determine if a struct se_cmd is associated with
 	 * this struct iscsi_cmd.
 	 */
 	switch (cmd->iscsi_opcode) {
-- 
1.7.12.rc3.4.g91e4bfe

